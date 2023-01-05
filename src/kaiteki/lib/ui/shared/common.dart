import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';

const centeredCircularProgressIndicator = Center(
  child: CircularProgressIndicator(),
);

Future<void> showTextAlert(BuildContext context, String title, String body) {
  return showDialog(
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          child: Text(context.materialL10n.okButtonLabel),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
    context: context,
  );
}
