import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/auth/login_functions.dart';
import 'package:kaiteki/auth/login_typedefs.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/instance_prober.dart';
import 'package:kaiteki/fediverse/model/instance.dart';
import 'package:kaiteki/ui/auth/login/api_type_dialog.dart';
import 'package:kaiteki/ui/auth/login/login_form.dart';
import 'package:kaiteki/ui/auth/login/mfa_dialog.dart';
import 'package:kaiteki/ui/shared/async_block_widget.dart';
import 'package:kaiteki/ui/shared/form_widget.dart';
import 'package:kaiteki/ui/shared/icon_landing_widget.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _loading = false;
  String? _error;
  Instance? _instance;
  String? background;
  ApiType? _type;
  Function()? _oAuth;

  final _loginFormKey = GlobalKey<LoginFormState>();

  @override
  Widget build(BuildContext context) {
    final instance = _instance;
    final hasBackground = instance?.backgroundUrl != null;
    final l10n = context.getL10n();

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        color: Theme.of(context).canvasColor,
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: hasBackground ? 1.0 : 0.0,
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 500),
                child: background == null
                    ? Container()
                    : Image.network(background!, fit: BoxFit.cover),
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(
                  instance == null || instance.name.isEmpty
                      ? l10n.loginTitle
                      : l10n.loginTitleInstance(instance.name),
                ),
                automaticallyImplyLeading: !_loading,
              ),
              body: FormWidget(
                padding: EdgeInsets.zero,
                builder: (context, fillsPage) {
                  final formWidgetColor = Theme.of(context)
                      .cardColor
                      .withOpacity(fillsPage ? .9 : 0);

                  return ColoredBox(
                    color: formWidgetColor,
                    child: SizedBox(
                      height: double.infinity,
                      child: PageTransitionSwitcher(
                        // key: _transitionKey,
                        transitionBuilder: _buildTransition,
                        duration: const Duration(milliseconds: 750),
                        // reverse: !showAuthentication,
                        child: _oAuth != null
                            ? _buildOAuthPage()
                            : _buildLoginForm(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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

  AsyncBlockWidget _buildLoginForm() {
    return AsyncBlockWidget(
      blocking: _loading,
      duration: const Duration(milliseconds: 250),
      secondChild: const Center(
        child: CircularProgressIndicator(),
      ),
      child: LoginForm(
        key: _loginFormKey,
        onValidateInstance: validateInstance,
        onValidateUsername: validateUsername,
        onValidatePassword: validatePassword,
        currentError: _error,
        onLogin: (instance, username, password) async {
          final future = loginButtonPress(
            instance,
            username,
            password,
          );
          return asyncWrapper(future);
        },
        onFetchInstance: (instance) {
          final future = fetchInstance(instance);
          return asyncWrapper(future);
        },
        onResetInstance: () => setState(() {
          _type = null;
          _instance = null;
        }),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_loading) {
      return false;
    }

    _loginFormKey.currentState!.onBackButtonPressed();
    return false;
  }

  Future<T> asyncWrapper<T>(Future<T> future) {
    setState(() {
      _error = null;
      _loading = true;
    });

    return future.catchError((e) {
      setState(() {
        _error = e.toString();
      });
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }

  Future<Instance?> fetchInstance(String instanceHost) async {
    final result = await probeInstance(instanceHost);
    final ApiType? type;
    final Instance instance;

    if (result.successful) {
      // ignore: unnecessary_null_checks
      type = result.type!;
      instance = result.instance!;
    } else {
      if (!mounted) {
        throw Exception("oopsie woopsie, mounted is false");
        // If this triggers `dead_code`, why doesn't it make
        // `use_build_context_synchronously` go away?
        // ignore: dead_code
        return null;
      }

      type = await showInstanceDialog(context);

      if (type == null) {
        return null;
      }

      final adapter = type.createAdapter();
      adapter.client.instance = instanceHost;
      instance = await adapter.getInstance();
    }

    // Check for known issue with Misskey instances
    if (kIsWeb && type == ApiType.misskey) {
      // if (!await _showWebCompatibilityDialog()) {
      //   return null;
      // }
    }

    _type = type;
    _instance = instance;

    // Set background
    if (_instance != null) {
      setState(() => background = _instance!.backgroundUrl);
    }

    return _instance;
  }

  Future<ApiType?> showInstanceDialog(BuildContext context) async {
    return showDialog<ApiType?>(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Center(child: ApiTypeDialog()),
    );
  }

  String? validateInstance(String? instance) {
    final l10n = context.getL10n();

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
    final l10n = context.getL10n();

    if (password.isNullOrEmpty) {
      return l10n.authNoPassword;
    }

    return null;
  }

  String? validateUsername(String? instance, String? username) {
    final l10n = context.getL10n();

    if (username.isNullOrEmpty) {
      return l10n.authNoUsername;
    }

    final accounts = ref.read(accountProvider);
    if (accounts.accounts.any(
      (compound) =>
          compound.instance == instance &&
          compound.accountSecret.username == username,
    )) {
      return l10n.authDuplicate;
    }

    return null;
  }

  Future<String?> requestMfa() async {
    final code = await showDialog(
      context: context,
      builder: (context) => const MfaDialog(),
      barrierDismissible: false,
    );

    return code;
  }

  Future<void> loginButtonPress(
    String instance,
    String username,
    String password,
  ) async {
    final navigator = Navigator.of(context);
    final accounts = ref.read(accountProvider);
    final adapter = _type!.createAdapter();
    final result = await adapter.login(
      instance,
      username,
      password,
      requestMfa,
      handleOAuth,
      accounts,
    );

    if (result.successful) {
      navigator.pop();
    } else {
      setState(() => _error = result.reason);
    }
  }

  Future<void> runAsync() async {}

  Widget _buildOAuthPage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const IconLandingWidget(
          icon: Icon(Icons.key_rounded),
          text: Text("Waiting for OAuth..."),
        ),
        const SizedBox(height: 16),
        OutlinedButton(onPressed: _oAuth, child: const Text("Cancel")),
      ],
    );
  }

  Future<Map<String, String>?> handleOAuth(
    GenerateOAuthUrlCallback generateUrl,
  ) async {
    final response = await runOAuthServer((localUrl, cancel) async {
      // TODO(Craftplacer): Show WebView inside login screen when possible
      try {
        final generatedUrl = await generateUrl(localUrl);
        await launchUrl(generatedUrl);
        setState(() => _oAuth = cancel);
      } catch (_) {
        // TODO(Craftplacer): log error
        cancel();
      }
    });
    setState(() => _oAuth = null);
    return response;
  }
}
