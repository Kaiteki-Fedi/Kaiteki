import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/instance.dart';
import 'package:kaiteki/ui/auth/login/login_form.dart';
import 'package:kaiteki/ui/shared/form_widget.dart';
import 'package:kaiteki/utils/extensions.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  Instance? _instance;

  final _loginFormKey = GlobalKey<LoginFormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();
    final instanceName = _instance?.name;
    final instanceBackgroundUrl = _instance?.backgroundUrl;

    return Container(
      color: Theme.of(context).canvasColor,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: instanceBackgroundUrl == null ? 0.0 : 1.0,
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 500),
              child: instanceBackgroundUrl == null
                  ? Container()
                  : Image.network(instanceBackgroundUrl, fit: BoxFit.cover),
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
                final formWidgetColor =
                    Theme.of(context).cardColor.withOpacity(fillsPage ? .9 : 0);

                return ColoredBox(
                  color: formWidgetColor,
                  child: SizedBox(
                    height: double.infinity,
                    child: LoginForm(
                      key: _loginFormKey,
                      onInstanceChanged: (instance) {
                        setState(() => _instance = instance?.data);
                      },
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
    return password.isNullOrEmpty ? l10n.authNoPassword : null;
  }

  String? validateUsername(String? instance, String? username) {
    final l10n = context.getL10n();

    if (username.isNullOrEmpty) return l10n.authNoUsername;

    final manager = ref.read(accountProvider);
    if (manager.accounts.any(
      (account) {
        return account.key.host == instance && account.key.username == username;
      },
    )) {
      return l10n.authDuplicate;
    }

    return null;
  }
}
