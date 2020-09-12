import 'package:flutter/material.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/api/api_type.dart';
import 'package:kaiteki/auth/login_typedefs.dart';
import 'package:kaiteki/ui/forms/login_form.dart';
import 'package:kaiteki/ui/screens/auth/mfa_screen.dart';
import 'package:provider/provider.dart';

// TODO: Try to make this screen standalone and not rely on any specific client
//       implementations.
class LoginScreen extends StatefulWidget {
  LoginScreen({this.image, this.color, this.backgroundColor, this.onLogin, this.type, Key key}) : super(key: key);

  final ImageProvider image;
  final Color color;
  final Color backgroundColor;
  final ApiType type;

  final LoginCallback onLogin;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _instanceController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  String _error;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _getTheme(),
      child: Scaffold(
        appBar: AppBar(title: Text("Log into an instance")),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (_loading)
              Center(child: CircularProgressIndicator());

            const double contentWidth = 450;
            const double contentHeight = 600;

            if (contentWidth <= constraints.maxWidth && contentHeight <= constraints.maxHeight)
              return Stack(
                children: [
                  Center(
                    child: Card(
                      child: Container(
                        width: contentWidth,
                        height: contentHeight,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 64.0,
                        ),
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
                            LoginForm(
                              onValidateInstance: validateInstance,
                              onValidateUsername: validateUsername,
                              onValidatePassword: validatePassword,
                              currentError: _error,
                              onLogin: loginButtonPress,
                              instanceController: _instanceController,
                              usernameController: _usernameController,
                              passwordController: _passwordController,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Image(
                    image: widget.image,
                    width: 64,
                    height: 64,
                  ),
                ),
                LoginForm(
                  onValidateInstance: validateInstance,
                  onValidateUsername: validateUsername,
                  onValidatePassword: validatePassword,
                  currentError: _error,
                  onLogin: loginButtonPress,
                  instanceController: _instanceController,
                  usernameController: _usernameController,
                  passwordController: _passwordController,
                )
              ],
            );
          },

        )
      ),
    );
  }

  ThemeData _getTheme() {
    var colorScheme = ColorScheme(
      primary: widget.color,
      primaryVariant: widget.color,
      secondary: widget.color,
      secondaryVariant: widget.color,

      background: widget.backgroundColor,
      surface: widget.backgroundColor,

      onBackground: Colors.white,
      onSurface: Colors.white,
      onPrimary: widget.backgroundColor,
      onSecondary: widget.backgroundColor,

      error: Colors.red,
      onError: Colors.black,

      brightness: Brightness.dark,
    );

    return ThemeData
      .from(colorScheme: colorScheme)
      .copyWith(
        buttonColor: widget.color,
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
        ),
        cursorColor: widget.color,
        appBarTheme: AppBarTheme(elevation: 0),
      );
  }

  String validateInstance(String instance) {
    if (instance.isEmpty)
      return "Please enter an instance";

    var lowerCase = instance.toLowerCase();
    if (lowerCase.startsWith("http://") || lowerCase.startsWith("https://"))
      return "Please only provide the domain name";

    return null;
  }
  String validatePassword(String password) {
    if (password.isEmpty)
      return "Please enter a password";

    return null;
  }
  String validateUsername(String username) {
    if (username.isEmpty)
      return "Please enter an username";

    return null;
  }

  Future<String> requestMfa() async {
    var route = MaterialPageRoute(builder: (_) => MfaScreen());
    var code = await Navigator.of(context).push(route);
    return code;
  }

  void loginButtonPress() async {
    try {
      setState(() => _loading = true);

      var accountContainer = Provider.of<AccountContainer>(context, listen: false);

      var result = await widget.onLogin.call(
        _instanceController.value.text,
        _usernameController.value.text,
        _passwordController.value.text,
        requestMfa,
        accountContainer,
      );

      if (!result.successful)
        setState(() => _error = result.reason);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }
}