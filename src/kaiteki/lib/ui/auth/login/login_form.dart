import 'dart:async';

import 'package:animations/animations.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/auth/login_functions.dart';
import 'package:kaiteki/auth/login_typedefs.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/instance_prober.dart';
import 'package:kaiteki/fediverse/model/instance.dart';
import 'package:kaiteki/ui/auth/login/dialogs/api_type_dialog.dart';
import 'package:kaiteki/ui/auth/login/pages/instance_page.dart';
import 'package:kaiteki/ui/auth/login/pages/mfa_page.dart';
import 'package:kaiteki/ui/auth/login/pages/oauth_page.dart';
import 'package:kaiteki/ui/auth/login/pages/user_page.dart';
import 'package:kaiteki/ui/shared/async/async_block_widget.dart';
import 'package:kaiteki/ui/shared/dialogs/authentication_unsuccessful_dialog.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

const iconConstraint = BoxConstraints.tightFor(width: 48, height: 24);
const fieldMargin = EdgeInsets.symmetric(vertical: 8.0);
const fieldPadding = EdgeInsets.all(8.0);

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({
    super.key,
    this.onInstanceChanged,
  });

  final void Function(InstanceCompound? compound)? onInstanceChanged;

  @override
  LoginFormState createState() => LoginFormState();
}

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

  BackendAdapter createAdapter() => type.createAdapter(host);
}

class CallbackRequest<T, K extends Function> {
  final Completer<T> completer;
  final K callback;

  const CallbackRequest(this.completer, this.callback);
}

class LoginFormState extends ConsumerState<LoginForm> {
  InstanceCompound? _instance;
  InstanceCompound? get instance => _instance;
  set instance(InstanceCompound? instance) {
    if (instance == _instance) return;
    assert(mounted);
    setState(() => _instance = instance);
    widget.onInstanceChanged?.call(_instance);
  }

  CallbackRequest<void, CredentialsSubmitCallback>? _credentialRequest;
  CallbackRequest<void, MfaSubmitCallback>? _mfaRequest;
  VoidCallback? _oAuth;

  CancelableOperation<InstanceCompound?>? _fetchInstanceFuture;

  Future<void>? _loginFuture;

  @override
  void dispose() {
    // Avoid setting state when widget becomes unmounted
    _fetchInstanceFuture?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackButtonPressed,
      child: PageTransitionSwitcher(
        transitionBuilder: _buildTransition,
        duration: const Duration(milliseconds: 750),
        child: _buildPage(),
      ),
    );
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
    final request = _credentialRequest ?? _mfaRequest;
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
    if (instance != null) {
      instance = null;
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

          await launchUrl(generatedUrl);
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

      final adapter = type.createAdapter(host);
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

  Future<T?> _askForMfa<T>(MfaSubmitCallback<T> onSubmit) async {
    assert(_mfaRequest == null, "MFA is already being requested");

    final completer = Completer<T?>();

    setState(() => _mfaRequest = CallbackRequest(completer, onSubmit));

    try {
      return await completer.future;
    } finally {
      setState(() => _mfaRequest = null);
    }
  }

  Future<void> _login(InstanceCompound instance) async {
    final accounts = ref.read(accountProvider);
    final adapter = instance.createAdapter();

    final result = await adapter.login(
      await accounts.getClientSecret(instance.host),
      _askForCredentials,
      _askForMfa,
      _handleOAuth,
    );

    if (result.successful) {
      final account = result.account!;
      if (account.accountSecret == null) {
        await _showTemporaryAccountNotice();
      }

      await accounts.add(account);
      accounts.current = account;

      if (mounted) {
        Navigator.of(context).pop();
      }

      return;
    }

    if (!result.aborted) {
      final error = result.error!;
      _showError(error.item1, error.item2);
      return;
    }
  }

  Future<void> _showError(dynamic error, StackTrace? stack) async {
    await showDialog(
      context: context,
      builder: (_) => AuthenticationUnsuccessfulDialog(
        error: Tuple2(error, stack),
      ),
    );
  }

  Widget _buildPage() {
    if (_oAuth != null) return Center(child: OAuthPage(onCancel: _oAuth));

    final credentialRequest = _credentialRequest;
    if (credentialRequest != null) {
      return UserPage(
        image: _instance?.data.iconUrl,
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

    final mfaRequest = _mfaRequest;
    if (mfaRequest != null) {
      return MfaPage(
        onSubmit: (code) async {
          final result = await mfaRequest.callback(code);
          mfaRequest.completer.complete(result);
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
          secondChild: const Center(child: CircularProgressIndicator()),
          child: InstancePage(
            enabled: !isBusy,
            onNext: (host) {
              setState(() {
                // ignore: unnecessary_lambdas, I intentionally want this method not to return a future so the dialog isn't
                _loginFuture = _loginToInstance(host).catchError((e, s) {
                  _showError(e, s);
                }).then((_) => instance = null);
              });
            },
          ),
        );
      },
    );
  }

  Future<void> _loginToInstance(String host) async {
    assert(_fetchInstanceFuture == null);
    _fetchInstanceFuture = CancelableOperation.fromFuture(_fetchInstance(host));

    try {
      final instance = await _fetchInstanceFuture!.valueOrCancellation();
      if (instance == null) return;

      this.instance = instance;
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
              child: Text(context.getMaterialL10n().okButtonLabel),
            ),
          ],
        );
      },
    );
  }
}
