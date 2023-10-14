import "dart:async";
import "dart:convert";
import "dart:io";

import "package:animations/animations.dart";
import "package:async/async.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/auth/oauth.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/instance_prober.dart";
import "package:kaiteki/model/auth/account.dart";
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
import "package:kaiteki_core/social.dart";
import "package:kaiteki_core/utils.dart";
import "package:logging/logging.dart";
import "package:url_launcher/url_launcher.dart";

final kOAuthPage = Uri.https("kaiteki.app", "/oauth");

T Function(T value) getDefaultSubmitCallback<T>() => (value) => value;

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
  static final _logger = Logger("LoginScreen");

  InstanceCompound? _instance;
  CallbackRequest<Credentials?, CredentialsSubmitCallback>? _credentialRequest;
  CallbackRequest<String?, CodeSubmitCallback>? _codeRequest;
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
        } catch (e, s) {
          _showError((e, s));
        } finally {
          setState(() => _instance = null);
        }
      }();
    }
  }

  @override
  void dispose() {
    _credentialRequest?.completer.complete(null);
    _codeRequest?.completer.complete(null);
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
                      errorBuilder: (_, __, ___) => const SizedBox(),
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
                    child: PopScope(
                      canPop: false,
                      onPopInvoked: _onPopInvoked,
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

    // var accounts = ref.read(currentAccountProvider);
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

  Future<void> _onPopInvoked(bool didPop) async {
    if (didPop) return;

    final navigator = Navigator.of(context);

    // Cancel ongoing requests for user input.
    final request = _credentialRequest ?? _codeRequest;
    if (request != null) {
      request.completer.complete(null);
      return;
    }

    // Cancel ongoing OAuth requests.
    if (_oAuth != null) {
      _oAuth!();
      return;
    }

    // Reset instance
    if (_instance != null) {
      setState(() => _instance = null);
      return;
    }

    navigator.pop();
  }

  Future<LoginResult> _oauthLocalServer(
    BackendAdapter adapter,
    OAuthInitCallback generateUrl,
  ) async {
    final successPage =
        await generateLandingPage(Theme.of(context).colorScheme);

    try {
      Map<String, String>? extra;

      final query = await runServer(
        (localUrl, cancel) async {
          // TODO(Craftplacer): Show WebView inside login screen when possible
          final Uri generatedUrl;

          (generatedUrl, extra) = await generateUrl(localUrl);

          final canLaunch = await canLaunchUrl(generatedUrl);
          if (!canLaunch) throw Exception("Invalid URL");

          await launchUrl(generatedUrl, mode: LaunchMode.externalApplication);
          setState(() => _oAuth = cancel);
        },
        successPage,
      );

      if (query == null) return const LoginAborted();

      final receiver = adapter as OAuthReceiver;
      return receiver.handleOAuth(query, extra);
    } finally {
      setState(() => _oAuth = null);
    }
  }

  Future<LoginResult> _oauthQueryEncode(
    BackendAdapter adapter,
    OAuthInitCallback generateUrl,
  ) async {
    final (generatedUrl, extra) = await generateUrl(kOAuthPage);

    await launchUrl(
      generatedUrl,
      mode: LaunchMode.externalApplication,
    );

    final code = await _askForCode(
      const CodePromptOptions(),
      (code) async => code,
    );

    if (code == null) return const LoginAborted();

    try {
      final json = utf8.decode(base64Decode(code));
      final object = jsonDecode(json) as Map<String, dynamic>;
      final query = object.cast<String, String>();

      final receiver = adapter as OAuthReceiver;
      return receiver.handleOAuth(query, extra);
    } catch (e, s) {
      _logger.warning("Malformed base64 input for OAuth", e, s);
    }

    return const LoginAborted();
  }

  Future<LoginResult> _oauthDeepLink(
    BackendAdapter adapter,
    OAuthInitCallback generateUrl,
  ) async {
    // If the adapter is not decentralized, then it won't matter what the host
    // is, so we can just use a placeholder.
    final host =
        adapter.safeCast<DecentralizedBackendAdapter>()?.instance ?? "woozy";
    final redirectUri = getRedirectUri(adapter.type, host);

    if (redirectUri == null) {
      return LoginFailure(
        (UnsupportedError("Couldn't generate redirect URI"), null),
      );
    }

    final (url, extra) = await generateUrl(redirectUri);

    if (extra != null) {
      await pushExtra(
        ref.read(sharedPreferencesProvider),
        adapter.type,
        host,
        extra,
      );
    }

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: "_self",
    );

    return const LoginAborted();
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

    return InstanceCompound(host, type, instance);
  }

  Future<ApiType?> showInstanceDialog(BuildContext context) async {
    return showDialog<ApiType?>(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Center(child: ApiTypeDialog()),
    );
  }

  Future<Credentials?> _askForCredentials([
    CredentialsSubmitCallback? onSubmit,
  ]) async {
    assert(
      _credentialRequest == null,
      "Credentials are already being asked for",
    );

    final completer = Completer<Credentials?>();

    setState(
      () => _credentialRequest = CallbackRequest(
        completer,
        onSubmit ?? (code) => code,
      ),
    );

    try {
      return await completer.future;
    } finally {
      setState(() => _credentialRequest = null);
    }
  }

  Future<String?> _askForCode(
    CodePromptOptions options, [
    CodeSubmitCallback? onSubmit,
  ]) async {
    assert(_codeRequest == null, "A code is already being requested");

    final completer = Completer<String?>();

    setState(() {
      _codeRequest = CallbackRequest(completer, onSubmit ?? (_) {});
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
    final router = GoRouter.of(context);

    final accountManager = ref.read(accountManagerProvider.notifier);
    final adapter = await instance.createAdapter();

    final loginInterface = adapter as LoginSupport;

    final clientSecret = await accountManager.getClientSecret(instance.host);
    final loginContext = LoginContext(
      clientSecret:
          clientSecret.nullTransform((e) => (e.clientId, e.clientSecret)),
      requestCredentials: _askForCredentials,
      requestCode: _askForCode,
      requestOAuth: (generateUrl, [extra]) {
        assert(adapter is OAuthReceiver);

        if (kIsWeb && getBaseUri() == null) {
          return _oauthQueryEncode(adapter, generateUrl);
        }

        if (kIsWeb || Platform.isAndroid) {
          return _oauthDeepLink(adapter, generateUrl);
        }

        return _oauthLocalServer(adapter, generateUrl);
      },
      openUrl: (uri) async {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      },
      application: kAppId,
    );

    final result = await loginInterface.login(loginContext);

    if (result is! LoginSuccess) {
      if (result is LoginFailure) _showError(result.error);
      return;
    }

    final account = Account.fromLoginResult(
      result,
      adapter,
      instance.host,
    );

    if (account.accountSecret == null) {
      await _showTemporaryAccountNotice();
    }

    if (!mounted) {
      _logger.warning(
        "Login screen was unmounted before login could be completed",
      );
      return;
    }

    if (widget.popOnly) {
      router.pop(account);
      return;
    }

    await accountManager.add(account);
    router.goNamed("home", pathParameters: account.key.routerParams);
  }

  Future<void> _showError(TraceableError error) async {
    await showDialog(
      context: context,
      builder: (_) => AuthenticationUnsuccessfulDialog(
        error: error,
      ),
    );
  }

  Widget _buildPage() {
    if (_oAuth != null) return OAuthPage(onCancel: _oAuth);

    final credentialRequest = _credentialRequest;
    if (credentialRequest != null) {
      return UserPage(
        image: _instance?.data.iconUrl.toString(),
        onSubmit: (username, password) async {
          final credentials = Credentials(username, password);
          // Technically we could directly pass the future to the Completer, but
          // this would move the place where the error is raised to the
          // askForCredentials method and not UserPage wanting to show the
          // error.
          await credentialRequest.callback(credentials);
          credentialRequest.completer.complete();
        },
      );
    }

    final codeRequest = _codeRequest;
    if (codeRequest != null) {
      return CodePage(
        options: _codeOptions!,
        onSubmit: (code) async {
          await codeRequest.callback(code);
          codeRequest.completer.complete(code);
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
        } catch (e, s) {
          _showError((e, s));
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
            constraints: kDialogConstraints,
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
