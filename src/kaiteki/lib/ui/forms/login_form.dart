import 'package:flutter/material.dart';
import 'package:kaiteki/utils/lower_case_text_formatter.dart';
import 'package:mdi/mdi.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
    required this.instanceController,
    required this.usernameController,
    required this.passwordController,
    required this.onValidateInstance,
    required this.onValidateUsername,
    required this.onValidatePassword,
    required this.onLogin,
    required this.onRegister,
    this.currentError,
  }) : super(key: key);

  final TextEditingController instanceController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  final FormFieldValidator<String?> onValidateInstance;
  final FormFieldValidator<String?> onValidateUsername;
  final FormFieldValidator<String?> onValidatePassword;

  final VoidCallback onLogin;
  final VoidCallback onRegister;

  final String? currentError;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var iconConstraint = const BoxConstraints.tightFor(width: 48, height: 24);
    var theme = Theme.of(context);
    var fieldMargin = const EdgeInsets.symmetric(vertical: 8.0);
    var fieldPadding = const EdgeInsets.all(8.0);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AutofillGroup(
        child: Column(
          children: [
            Padding(
              padding: fieldMargin,
              child: TextFormField(
                controller: widget.instanceController,
                decoration: InputDecoration(
                  hintText: "Instance",
                  prefixIcon: const Icon(Mdi.earth),
                  prefixIconConstraints: iconConstraint,
                  // TODO verify instance
                  // suffixIcon: Icon(Mdi.check),//CircularProgressIndicator(),
                  // suffixIconConstraints: iconConstraint
                  border: const OutlineInputBorder(),
                  contentPadding: fieldPadding,
                ),
                validator: widget.onValidateInstance,
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
                controller: widget.usernameController,
                decoration: InputDecoration(
                  hintText: "Username",
                  prefixIcon: const Icon(Mdi.account),
                  prefixIconConstraints: iconConstraint,
                  border: const OutlineInputBorder(),
                  contentPadding: fieldPadding,
                ),
                validator: widget.onValidateUsername,
                // ---
                autofillHints: const [AutofillHints.username],
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: fieldMargin,
              child: TextFormField(
                controller: widget.passwordController,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Mdi.key),
                  prefixIconConstraints: iconConstraint,
                  border: const OutlineInputBorder(),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  child: const Text("Need an account?"),
                  onPressed: widget.onRegister,
                ),
                ElevatedButton(
                  child: const Text("Login"),
                  onPressed: widget.onLogin,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
