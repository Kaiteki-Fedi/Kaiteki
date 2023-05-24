import "dart:async";

import "package:animations/animations.dart";
import "package:async/async.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/auth/login_functions.dart";
import "package:kaiteki/auth/login_typedefs.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/adapter.dart";
import "package:kaiteki/fediverse/api_type.dart";
import "package:kaiteki/fediverse/instance_prober.dart";
import "package:kaiteki/fediverse/model/instance.dart";
import "package:kaiteki/ui/auth/login/dialogs/api_type_dialog.dart";
import "package:kaiteki/ui/auth/login/pages/code_page.dart";
import "package:kaiteki/ui/auth/login/pages/handoff_page.dart";
import "package:kaiteki/ui/auth/login/pages/instance_page.dart";
import "package:kaiteki/ui/auth/login/pages/oauth_page.dart";
import "package:kaiteki/ui/auth/login/pages/user_page.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/dialogs/authentication_unsuccessful_dialog.dart";
import "package:kaiteki/ui/shared/layout/form_widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_material/kaiteki_material.dart";
import "package:logging/logging.dart";
import "package:tuple/tuple.dart";
import "package:url_launcher/url_launcher.dart";

class LoginScreen extends ConsumerStatefulWidget {
  // Whether the login screen only should pop with an account, instead of
  // automatically adding the account to the manager and returning to the
  // main screen.
  final bool popOnly;

  final PrefillCredentials? prefillCredentials;

  const LoginScreen({
    super.key,
    this.popOnly = false,
    this.prefillCredentials,
  });

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class PrefillCredentials {
  final String? instance;
  final String? username;

  const PrefillCredentials({this.username, this.instance});
}

const iconConstraint = BoxConstraints.tightFor(width: 48, height: 24);
const fieldMargin = EdgeInsets.symmetric(vertical: 8.0);
const fieldPadding = EdgeInsets.all(8.0);

class InstanceCompound {
  final String host;
  final ApiType type;
  final Instance data;

  const InstanceCompound(this.host, this.type, this.data);

  @override
  bool operator ==(Object other) =>
      other is InstanceCompound &&
      host == other.host &&
      type == other.type &&
      data == other.data;

  @override
  int get hashCode => host.hashCode ^ type.hashCode ^ data.hashCode;

  Future<BackendAdapter> createAdapter() => type.createAdapter(host);
}

class CallbackRequest<T, K extends Function> {
  final Completer<T> completer;
  final K callback;

  const CallbackRequest(this.completer, this.callback);
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  InstanceCompound? _instance;
  CallbackRequest<void, CredentialsSubmitCallback>? _credentialRequest;
  CallbackRequest<void, CodeSubmitCallback>? _codeRequest;
  CodePromptOptions? _codeOptions;
  VoidCallback? _oAuth;

  CancelableOperation<InstanceCompound?>? _fetchInstanceFuture;

  Future<void>? _loginFuture;

  @override
  void initState() {
    super.initState();

    final host = widget.prefillCredentials?.instance;
    if (host != null) {
      _loginFuture = () async {
        try {
          await _loginToInstance(host);
        } catch (s, e) {
          _showError(s, e);
        } finally {
          setState(() => _instance = null);
        }
      }();
    }
  }

  @override
  void dispose() {
    // Avoid setting state when widget becomes unmounted
    _fetchInstanceFuture?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final instanceName = _instance?.data.name;
    final instanceBackgroundUrl = _instance?.data.backgroundUrl;

    return ColoredBox(
      color: Theme.of(context).canvasColor,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: instanceBackgroundUrl == null ? 0.0 : 1.0,
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 500),
              child: instanceBackgroundUrl == null
                  ? const SizedBox()
                  : Image.network(
                      instanceBackgroundUrl.toString(),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                instanceName == null || instanceName.isEmpty
                    ? l10n.loginTitle
                    : l10n.loginTitleInstance(instanceName),
              ),
              // automaticallyImplyLeading: !_loading,
            ),
            body: FormWidget(
              padding: EdgeInsets.zero,
              builder: (context, fillsPage) {
                final formWidgetColor = Theme.of(context)
                    .colorScheme
                    .surface
                    .withOpacity(fillsPage ? .9 : 0);

                return ColoredBox(
                  color: formWidgetColor,
                  child: SizedBox(
                    height: double.infinity,
                    child: WillPopScope(
                      onWillPop: _onBackButtonPressed,
                      child: PageTransitionSwitcher(
                        transitionBuilder: _buildTransition,
                        duration: const Duration(milliseconds: 750),
                        child: _buildPage(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String? validateInstance(String? instance) {
    final l10n = context.l10n;

    if (instance.isNullOrEmpty) {
      return l10n.authNoInstance;
    }

    final lowerCase = instance!.toLowerCase();
    if (lowerCase.startsWith("http://") || lowerCase.startsWith("https://")) {
      return l10n.authNoUrlAllowed;
    }

    // var accounts = ref.read(accountProvider);
    // if (accounts.accounts.any((compound) =>
    //     compound.instance == instance &&
    //     compound.accountSecret.username == username)) {
    //   return "There's already an account with the same instance and username";
    // }

    return null;
  }

  String? validatePassword(String? password) {
    final l10n = context.l10n;
    return password.isNullOrEmpty ? l10n.authNoPassword : null;
  }

  String? validateUsername(String? instance, String? username) {
    final l10n = context.l10n;

    if (username.isNullOrEmpty) return l10n.authNoUsername;

    final manager = ref.read(accountManagerProvider);
    if (manager.accounts.any(
      (account) {
        return account.key.host == instance && account.key.username == username;
      },
    )) {
      return l10n.authDuplicate;
    }

    return null;
  }

  Widget _buildTransition(
    Widget child,
    Animation<double> primaryAnimation,
    Animation<double> secondaryAnimation,
  ) {
    return SharedAxisTransition(
      animation: primaryAnimation,
      secondaryAnimation: secondaryAnimation,
      transitionType: SharedAxisTransitionType.horizontal,
      fillColor: Colors.transparent,
      child: child,
    );
  }

  Future<bool> _onBackButtonPressed() async {
    // Cancel ongoing requests for user input.
    final request = _credentialRequest ?? _codeRequest;
    if (request != null) {
      request.completer.complete(null);
      return false;
    }

    // Cancel ongoing OAuth requests.
    if (_oAuth != null) {
      _oAuth!();
      return false;
    }

    // Reset instance
    if (_instance != null) {
      setState(() => _instance = null);
      return false;
    }

    return true;
  }

  Future<Map<String, String>?> _handleOAuth(
    GenerateOAuthUrlCallback generateUrl,
  ) async {
    final successPage = await generateOAuthLandingPage(
      Theme.of(context).colorScheme,
    );

    try {
      return await runOAuthServer(
        (localUrl, cancel) async {
          // TODO(Craftplacer): Show WebView inside login screen when possible
          final generatedUrl = await generateUrl(localUrl);

          final canLaunch = await canLaunchUrl(generatedUrl);
          if (!canLaunch) throw Exception("Invalid URL");

          await launchUrl(generatedUrl, mode: LaunchMode.externalApplication);
          setState(() => _oAuth = cancel);
        },
        successPage,
      );
    } finally {
      setState(() => _oAuth = null);
    }
  }

  Future<InstanceCompound?> _fetchInstance(String host) async {
    final result = await ref.read(probeInstanceProvider(host).future);

    final ApiType type;
    final Instance instance;

    if (result.successful) {
      // ignore: unnecessary_null_checks
      type = result.type!;
      instance = result.instance!;
    } else {
      if (!mounted) return null;

      final selectedType = await showInstanceDialog(context);
      if (selectedType == null) return null;
      type = selectedType;

      final adapter = await type.createAdapter(host);
      instance = await adapter.getInstance();
    }

    // // Check for known issue with Misskey instances
    // if (kIsWeb && type == ApiType.misskey) {
    //   if (!await _showWebCompatibilityDialog()) {
    //     return null;
    //   }
    // }

    return InstanceCompound(host, type, instance);
  }

  Future<ApiType?> showInstanceDialog(BuildContext context) async {
    return showDialog<ApiType?>(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Center(child: ApiTypeDialog()),
    );
  }

  Future<T?> _askForCredentials<T>(
    CredentialsSubmitCallback<T> onSubmit,
  ) async {
    assert(
      _credentialRequest == null,
      "Credentials are already being asked for",
    );

    final completer = Completer<T?>();

    setState(() => _credentialRequest = CallbackRequest(completer, onSubmit));

    try {
      return await completer.future;
    } finally {
      setState(() => _credentialRequest = null);
    }
  }

  Future<T?> _askForCode<T>(
    CodePromptOptions options,
    CodeSubmitCallback<T> onSubmit,
  ) async {
    assert(_codeRequest == null, "A code is already being requested");

    final completer = Completer<T?>();

    setState(() {
      _codeRequest = CallbackRequest(completer, onSubmit);
      _codeOptions = options;
    });

    try {
      return await completer.future;
    } finally {
      setState(() {
        _codeRequest = null;
        _codeOptions = null;
      });
    }
  }

  Future<void> _login(InstanceCompound instance) async {
    final accounts = ref.read(accountManagerProvider);
    final adapter = await instance.createAdapter();

    final result = await adapter.login(
      await accounts.getClientSecret(instance.host),
      _askForCredentials,
      _askForCode,
      _handleOAuth,
    );

    if (result.aborted) return;

    if (!result.successful) {
      final error = result.error!;
      _showError(error.item1, error.item2);
      return;
    }

    final account = result.account!;
    if (account.accountSecret == null) {
      await _showTemporaryAccountNotice();
    }

    if (!mounted) {
      Logger("LoginScreen").warning(
          "Login screen was unmounted before login could be completed");
      return;
    }

    final router = GoRouter.of(context);

    if (widget.popOnly) {
      router.pop(account);
      return;
    }

    await accounts.add(account);
    router.goNamed("home", pathParameters: account.key.routerParams);
  }

  Future<void> _showError(Object error, StackTrace? stack) async {
    await showDialog(
      context: context,
      builder: (_) => AuthenticationUnsuccessfulDialog(
        error: Tuple2(error, stack),
      ),
    );
  }

  Widget _buildPage() {
    if (_oAuth != null) {
      return OAuthPage(onCancel: _oAuth);
    }

    final credentialRequest = _credentialRequest;
    if (credentialRequest != null) {
      return UserPage(
        image: _instance?.data.iconUrl.toString(),
        onBack: _onBackButtonPressed,
        onSubmit: (username, password) async {
          final credentials = Credentials(username, password);
          // Technically we could directly pass the future to the Completer, but
          // this would move the place where the error is raised to the
          // askForCredentials method and not UserPage wanting to show the
          // error.
          final result = await credentialRequest.callback(credentials);
          credentialRequest.completer.complete(result);
        },
      );
    }

    final codeRequest = _codeRequest;
    if (codeRequest != null) {
      return CodePage(
        options: _codeOptions!,
        onSubmit: (code) async {
          final result = await codeRequest.callback(code);
          codeRequest.completer.complete(result);
        },
      );
    }

    return FutureBuilder(
      future: _loginFuture,
      builder: (context, snapshot) {
        final isBusy = snapshot.connectionState == ConnectionState.waiting;
        return AsyncBlockWidget(
          blocking: isBusy,
          duration: const Duration(milliseconds: 250),
          secondChild: centeredCircularProgressIndicator,
          child: InstancePage(
            enabled: !isBusy,
            onHandoff: onHandoff,
            onNext: _onNextInstance,
          ),
        );
      },
    );
  }

  FutureOr<void> _onNextInstance(String host) {
    setState(() {
      _loginFuture = () async {
        try {
          await _loginToInstance(host);
        } catch (s, e) {
          _showError(s, e);
        } finally {
          setState(() => _instance = null);
        }
      }();
    });
  }

  Future<void> _loginToInstance(String host) async {
    assert(_fetchInstanceFuture == null);
    _fetchInstanceFuture = CancelableOperation.fromFuture(_fetchInstance(host));

    try {
      final instance = await _fetchInstanceFuture!.valueOrCancellation();
      if (instance == null) return;

      setState(() => _instance = instance);
      await _login(instance);
    } finally {
      _fetchInstanceFuture = null;
    }
  }

  Future<void> _showTemporaryAccountNotice() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.vpn_key_off_rounded),
          title: const Text("Your session will be temporary"),
          content: ConstrainedBox(
            constraints: dialogConstraints,
            child: const Text(
              "The backend implementation of this service did not provide login information when you signed in. This means that you'll be signed out next time you use Kaiteki.",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.materialL10n.okButtonLabel),
            ),
          ],
        );
      },
    );
  }

  Future<void> onHandoff() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const HandoffPage()),
    );
  }
}
