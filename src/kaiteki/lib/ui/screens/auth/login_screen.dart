import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/api/api_type.dart';
import 'package:kaiteki/fediverse/api/definitions/definitions.dart';
import 'package:kaiteki/fediverse/model/instance.dart';
import 'package:kaiteki/ui/dialogs/api_type_dialog.dart';
import 'package:kaiteki/ui/dialogs/mfa_dialog.dart';
import 'package:kaiteki/ui/forms/login_form.dart';
import 'package:kaiteki/ui/widgets/async_block_widget.dart';
import 'package:kaiteki/ui/widgets/layout/form_widget.dart';
import 'package:kaiteki/utils/extensions.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _loading = false;
  String? _error;
  Instance? _instance;
  String? background;
  ApiDefinition? _api;

  final _loginFormKey = GlobalKey<LoginFormState>();

  @override
  Widget build(BuildContext context) {
    final instance = _instance;
    final hasBackground = instance?.backgroundUrl != null;
    final l10n = context.getL10n();

    return WillPopScope(
      onWillPop: () async {
        if (_loading) {
          return false;
        }

        _loginFormKey.currentState!.onBackButtonPressed();
        return false;
      },
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
                title: Text(instance == null || instance.name.isEmpty
                    ? l10n.loginTitle
                    : l10n.loginTitleInstance(instance.name)),
                automaticallyImplyLeading: !_loading,
              ),
              body: FormWidget(
                padding: EdgeInsets.zero,
                builder: (context, fillsPage) {
                  return Container(
                    color: Theme.of(context).cardColor.withOpacity(
                          fillsPage ? .9 : 0,
                        ),
                    height: double.infinity,
                    child: AsyncBlockWidget(
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
                          return await asyncWrapper(future);
                        },
                        onFetchInstance: (instance) async {
                          final future = fetchInstance(instance);
                          return await asyncWrapper(future);
                        },
                        onResetInstance: () => setState(() {
                          _api = null;
                          _instance = null;
                        }),
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
    final accountManager = ref.read(accountProvider);
    final result = await accountManager.probeInstance(instanceHost);
    final ApiDefinition? api;
    final Instance instance;

    if (result.successful) {
      api = result.definition!;
      instance = result.instance!;
    } else {
      api = await showInstanceDialog(context);

      if (api == null) {
        return null;
      }

      final adapter = api.createAdapter();
      adapter.client.instance = instanceHost;
      instance = await adapter.getInstance();
    }

    // Check for known issue with Misskey instances
    if (kIsWeb && api.type == ApiType.misskey) {
      if (!await _showWebCompatibilityDialog()) {
        return null;
      }
    }

    _api = api;
    _instance = instance;

    // Set background
    if (_instance != null) {
      setState(() => background = _instance!.backgroundUrl);
    }

    return _instance;
  }

  Future<ApiDefinition?> showInstanceDialog(BuildContext context) async {
    return await showDialog<ApiDefinition?>(
      barrierDismissible: false,
      context: context,
      builder: (context) => const ApiTypeDialog(),
    );
  }

  String? validateInstance(String? instance) {
    final l10n = context.getL10n();

    if (instance.isNullOrEmpty) {
      return l10n.authNoInstance;
    }

    var lowerCase = instance!.toLowerCase();
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

    var accounts = ref.read(accountProvider);
    if (accounts.accounts.any((compound) =>
        compound.instance == instance &&
        compound.accountSecret.username == username)) {
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

  Future<bool> _showWebCompatibilityDialog() async {
    const String helpArticle =
        "https://github.com/Craftplacer/Kaiteki/wiki/Unable-to-login-using-Kaiteki-Web";

    final l10n = context.getL10n();
    final dialogResult = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(l10n.unsupportedInstanceTitle),
            content: Text.rich(
              TextSpan(
                text: l10n.unsupportedInstanceDescriptionCORS,
                style: Theme.of(context).textTheme.bodyText1,
                children: [
                  TextSpan(
                    text: helpArticle,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        await context.launchUrl(helpArticle);
                      },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text(l10n.continueAnywayButtonLabel),
                onPressed: () => Navigator.pop(context, true),
              ),
              TextButton(
                child: Text(l10n.abortButtonLabel),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });

    return dialogResult == true;
  }

  Future<void> loginButtonPress(
    String instance,
    String username,
    String password,
  ) async {
    final accounts = ref.read(accountProvider);
    final adapter = _api!.createAdapter();
    final result = await adapter.login(
      instance,
      username,
      password,
      requestMfa,
      accounts,
    );

    if (result.successful) {
      Navigator.of(context).pop();
    } else {
      setState(() => _error = result.reason);
    }
  }

  Future<void> runAsync() async {}
}
