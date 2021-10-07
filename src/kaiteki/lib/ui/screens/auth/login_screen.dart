import 'package:flutter/material.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/auth/login_typedefs.dart';
import 'package:kaiteki/fediverse/api/api_type.dart';
import 'package:kaiteki/ui/forms/login_form.dart';
import 'package:kaiteki/ui/screens/auth/mfa_screen.dart';
import 'package:kaiteki/ui/widgets/layout/form_widget.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    required this.image,
    required this.onLogin,
    required this.theme,
    required this.type,
    Key? key,
  }) : super(key: key);

  final ImageProvider image;
  final ApiType type;
  final ThemeData theme;

  final LoginCallback onLogin;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;
  String? _error;

  final GlobalKey _loginFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.theme,
      child: WillPopScope(
        onWillPop: () async => !_loading,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Log into an instance"),
            automaticallyImplyLeading: !_loading,
          ),
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (_loading) {
                return const Center(child: CircularProgressIndicator());
              }

              return FormWidget(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Image(
                          image: widget.image,
                          width: 64,
                          height: 64,
                        ),
                      ),
                      _getLoginForm(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _getLoginForm() {
    return LoginForm(
      key: _loginFormKey,
      onValidateInstance: validateInstance,
      onValidateUsername: validateUsername,
      onValidatePassword: validatePassword,
      currentError: _error,
      onLogin: loginButtonPress,
    );
  }

  String? validateInstance(String? instance, String? username) {
    if (instance.isNullOrEmpty) {
      return "Please enter an instance";
    }

    var lowerCase = instance!.toLowerCase();
    if (lowerCase.startsWith("http://") || lowerCase.startsWith("https://")) {
      return "Please only provide the domain name";
    }

    var accounts = Provider.of<AccountManager>(context, listen: false);
    if (accounts.accounts.any((compound) =>
        compound.instance == instance &&
        compound.accountSecret.username == username)) {
      return "There's already an account with the same instance and username";
    }

    return null;
  }

  String? validatePassword(String? password) {
    if (password.isNullOrEmpty) {
      return "Please enter a password";
    }

    return null;
  }

  String? validateUsername(String? instance, String? username) {
    if (username.isNullOrEmpty) {
      return "Please enter an username";
    }

    var accounts = Provider.of<AccountManager>(context, listen: false);
    if (accounts.accounts.any((compound) =>
        compound.instance == instance &&
        compound.accountSecret.username == username)) {
      return "There's already an account with the same instance and username";
    }

    return null;
  }

  Future<String> requestMfa() async {
    var route = MaterialPageRoute(builder: (_) => const MfaScreen());
    var code = await Navigator.of(context).push(route);
    return code;
  }

  void loginButtonPress(
    String instance,
    String username,
    String password,
  ) async {
    try {
      setState(() => _loading = true);

      var accountContainer =
          Provider.of<AccountManager>(context, listen: false);

      var result = await widget.onLogin.call(
        instance,
        username,
        password,
        requestMfa,
        accountContainer,
      );

      if (result.successful) {
        Navigator.of(context).pop();
      } else {
        setState(() => _error = result.reason);
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }
}
