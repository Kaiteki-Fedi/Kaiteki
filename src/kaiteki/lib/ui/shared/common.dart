import "package:flutter/material.dart";
import "package:kaiteki/di.dart";

export "package:kaiteki/common.dart";

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

extension ColorKaitekiExtension on Color {
  TextStyle get textStyle => TextStyle(color: this);
}

double getLocalFontSize(BuildContext context) {
  return DefaultTextStyle.of(context).style.fontSize!;
}

Color getLocalTextColor(BuildContext context) {
  return DefaultTextStyle.of(context).style.color!;
}
