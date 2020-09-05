import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kaiteki/model/account_compound.dart';
import 'package:kaiteki/model/login_result.dart';
import 'package:kaiteki/utils/lower_case_text_formatter.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/model/account_secret.dart';
import 'package:kaiteki/api/clients/pleroma_client.dart';
import 'package:kaiteki/model/client_secret.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/ui/screens/mfa_screen.dart';
import 'package:kaiteki/utils/logger.dart';
import 'package:kaiteki/utils/string_extensions.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

// TODO: Try to make this screen standalone and not rely on any specific client
//       implementations.
class LoginScreen extends StatefulWidget {
  LoginScreen({this.image, this.color, this.backgroundColor, this.onLogin, Key key}) : super(key: key);

  final ImageProvider image;
  final Color color;
  final Color backgroundColor;
  final Function<LoginResult>(String instance, String username, String password) onLogin;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _instanceController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  String _error;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var iconConstraint = BoxConstraints.tightFor(width: 48, height: 24);
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


    return Theme(
      data: ThemeData.from(
        colorScheme: colorScheme,
      ).copyWith(
        buttonTheme: ButtonThemeData(colorScheme: colorScheme),
        appBarTheme: AppBarTheme(elevation: 0),
      ),
      child: Scaffold(
        appBar: AppBar(title: Text("Log into an instance")),
        body: !_loading
          ? OrientationBuilder(
          builder: (_, o) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Image(
                  image: widget.image,
                  width: 96,
                  height: 96,
                ),
                Form(
                  key: _formKey,
                  child: AutofillGroup(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _instanceController,
                          decoration: InputDecoration(
                            hintText: "Instance",
                            prefixIcon: Icon(Mdi.earth),
                            prefixIconConstraints: iconConstraint,
                            // TODO: verify instance
                            // suffixIcon: Icon(Mdi.check),//CircularProgressIndicator(),
                            // suffixIconConstraints: iconConstraint
                          ),
                          keyboardType: TextInputType.url,
                          autofillHints: [AutofillHints.url ],
                          inputFormatters: [ LowerCaseTextFormatter() ],
                          validator: validateInstance,
                        ),
                        Divider(),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: "Username",
                            prefixIcon: Icon(Mdi.account),
                            prefixIconConstraints: iconConstraint,
                          ),
                          autofillHints: [ AutofillHints.username ],
                          keyboardType: TextInputType.text,
                          validator: validateUsername,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(Mdi.key),
                            prefixIconConstraints: iconConstraint,
                          ),
                          keyboardType: TextInputType.text,
                          enableSuggestions: false,
                          autocorrect: false,
                          autofillHints: [ AutofillHints.password ],
                          validator: validatePassword,
                        ),

                        if (_error != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(_error, style: TextStyle(color: Theme.of(context).errorColor)),
                          ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // TODO: https://github.com/Craftplacer/kaiteki/projects/1#card-42937000
                            FlatButton(
                              child: Text("Need an account?"),
                              onPressed: null,
                            ),
                            RaisedButton(
                              child: Text("Login"),
                              onPressed: loginButtonPress,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        )
        : Center(child: CircularProgressIndicator()),
      ),
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

  Future<ClientSecret> getClientSecret(PleromaClient client, String instance) async {
    var clientSecret = await ClientSecret.getSecret(instance);

    if (clientSecret == null)
      clientSecret = await createClientSecret(client, instance);

    return clientSecret;
  }

  Future<ClientSecret> createClientSecret(PleromaClient client, String instance) async {
    Logger.info("creating new application on $instance");

    var application = await client.createApplication(
      instance,
      Constants.appName,
      Constants.appWebsite,
      "urn:ietf:wg:oauth:2.0:oob",
      Constants.defaultScopes,
    );

    var clientSecret = ClientSecret(
      instance,
      application.clientId,
      application.clientSecret,
    );

    try {
      await clientSecret.save();
    } catch (e) {
      print("Failed to save client secret:\n$e");
    }

    return clientSecret;
  }

  Future<LoginResult> login(String instance, String username, String password) async {
    var client = PleromaClient()..instance = instance;

    // Retrieve or create client secret
    var clientSecret = await getClientSecret(client, instance);
    client.clientSecret = clientSecret.clientSecret;
    client.clientId = clientSecret.clientId;

    // Try to login and handle error
    var loginResponse = await client.login(username, password);
    if (loginResponse.error.isNotNullOrEmpty) {
      if (loginResponse.error == "mfa_required") {
        var screen = MfaScreen(mfaToken: loginResponse.mfaToken);
        var route = MaterialPageRoute(builder: (_) => screen);
        Navigator.pushReplacement(context, route);

        return LoginResult(pop: false);
      } else {
        return LoginResult(reason: loginResponse.error);
      }
    }

    // Create and set account secret
    var accountSecret = new AccountSecret(instance, username, loginResponse.accessToken);
    client.accessToken = accountSecret.accessToken;

    // Check whether secrets work, and if we can get an account back
    var account = await client.verifyCredentials();
    if (account == null) {
      return LoginResult(reason: "Failed to verify credentials");
    }

    var container = Provider.of<AccountContainer>(context, listen: false);
    var compound = AccountCompound(container, client, account, clientSecret, accountSecret);

    await container.addCurrentAccount(compound);
    return LoginResult();
  }

  void loginButtonPress() async {
    try {
      setState(() => _loading = true);

      var username = _usernameController.value.text;
      var password = _passwordController.value.text;
      var instance = _instanceController.value.text;


      var result = await login(instance, username, password);

      if (result.pop)
        Navigator.of(context).pop();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }
}