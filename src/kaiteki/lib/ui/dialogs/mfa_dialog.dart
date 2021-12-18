import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class MfaDialog extends StatefulWidget {
  const MfaDialog({Key? key}) : super(key: key);

  @override
  _MfaDialogState createState() => _MfaDialogState();
}

class _MfaDialogState extends State<MfaDialog> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isValid = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.mfaTitle),
      content: Form(
        key: _formKey,
        onChanged: _onFormChanged,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 300,
              child: TextFormField(
                autofillHints: const [AutofillHints.oneTimeCode],
                controller: _textController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.visiblePassword,
                maxLength: 6,
                style: GoogleFonts.robotoMono(fontSize: 24),
                textInputAction: TextInputAction.done,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autofocus: true,
                autocorrect: false,
                onFieldSubmitted: (code) => _submit(context, code),
                validator: (code) =>
                    code?.isEmpty == false ? null : l10n.mfaNoCode,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(l10n.cancelButtonLabel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(l10n.verifyButtonLabel),
          onPressed: isValid
              ? () => _submit(context, _textController.value.text)
              : null,
        ),
      ],
    );
  }

  void _submit(BuildContext context, String code) {
    Navigator.of(context).pop(code);
  }

  void _onFormChanged() {
    final isValid = _formKey.currentState!.validate();
    setState(() => this.isValid = isValid);
  }
}
