import "package:flutter/material.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";

class LinkWarningDialog extends StatelessWidget {
  final Uri url;

  const LinkWarningDialog(this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.front_hand_rounded),
      title: const Text("You are about to leave Kaiteki"),
      content: ConstrainedBox(
        constraints: kDialogConstraints,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("This link leads to $url."),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: false,
              onChanged: null,
              title: Text("Don't ask me again for ${url.host}"),
              secondary: const SizedBox(),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(context.materialL10n.okButtonLabel),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
