import "package:flutter/material.dart";

class AccountDeletionAuthenticationPage extends StatefulWidget {
  const AccountDeletionAuthenticationPage({super.key});

  @override
  State<AccountDeletionAuthenticationPage> createState() =>
      AccountDeletionAuthenticationPageState();
}

class AccountDeletionAuthenticationPageState
    extends State<AccountDeletionAuthenticationPage> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  String? get password {
    if (_formKey.currentState?.validate() != true) return null;
    return _textController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "To continue deleting your account, please enter your password to confirm.",
        ),
        const SizedBox(height: 16.0),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _textController,
                autocorrect: false,
                autofocus: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: true,
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.continueAction,
                validator: (input) => input?.isNotEmpty == true
                    ? null
                    : "Please enter your password",
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
