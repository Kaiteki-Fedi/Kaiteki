import 'package:flutter/material.dart';

class CancelTextButton extends StatelessWidget {
  const CancelTextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).maybePop(),
      child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
    );
  }
}
