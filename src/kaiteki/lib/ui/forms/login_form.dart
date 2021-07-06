import 'package:flutter/material.dart';
import 'package:kaiteki/utils/lower_case_text_formatter.dart';
import 'package:mdi/mdi.dart';

typedef CredentialsCallback = void Function(
  String instance,
  String username,
  String password,
);

typedef IdValidationCallback = String? Function(
  String? instance,
  String? username,
);

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
    required this.onValidateInstance,
    required this.onValidateUsername,
    required this.onValidatePassword,
    required this.onLogin,
    this.enabled = true,
    this.currentError,
  }) : super(key: key);

  final bool enabled;

  final IdValidationCallback onValidateInstance;
  final IdValidationCallback onValidateUsername;
  final FormFieldValidator<String?> onValidatePassword;

  final CredentialsCallback onLogin;

  final String? currentError;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _instanceController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const iconConstraint = BoxConstraints.tightFor(width: 48, height: 24);
    const fieldMargin = EdgeInsets.symmetric(vertical: 8.0);
    const fieldPadding = EdgeInsets.all(8.0);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AutofillGroup(
        child: Column(
          children: [
            Padding(
              padding: fieldMargin,
              child: TextFormField(
                controller: _instanceController,
                decoration: const InputDecoration(
                  hintText: "Instance",
                  prefixIcon: Icon(Mdi.earth),
                  prefixIconConstraints: iconConstraint,
                  border: OutlineInputBorder(),
                  contentPadding: fieldPadding,
                ),
                validator: (instance) {
                  return widget.onValidateInstance.call(
                    instance,
                    _usernameController.text,
                  );
                },
                // ---
                keyboardType: TextInputType.url,
                autofillHints: const [AutofillHints.url],
                inputFormatters: [LowerCaseTextFormatter()],
              ),
            ),
            const Divider(),
            Padding(
              padding: fieldMargin,
              child: TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  hintText: "Username",
                  prefixIcon: Icon(Mdi.account),
                  prefixIconConstraints: iconConstraint,
                  border: OutlineInputBorder(),
                  contentPadding: fieldPadding,
                ),
                validator: (username) {
                  return widget.onValidateUsername.call(
                    _instanceController.text,
                    username,
                  );
                },
                // ---
                autofillHints: const [AutofillHints.username],
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: fieldMargin,
              child: TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(Mdi.key),
                  prefixIconConstraints: iconConstraint,
                  border: OutlineInputBorder(),
                  contentPadding: fieldPadding,
                ),
                validator: widget.onValidatePassword,
                // ---
                keyboardType: TextInputType.text,
                autofillHints: const [AutofillHints.password],
                obscureText: true,
              ),
            ),
            if (widget.currentError != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.currentError!,
                  style: TextStyle(color: theme.errorColor),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  child: const Text("Login"),
                  onPressed: () {
                    widget.onLogin.call(
                      _instanceController.text,
                      _usernameController.text,
                      _passwordController.text,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
