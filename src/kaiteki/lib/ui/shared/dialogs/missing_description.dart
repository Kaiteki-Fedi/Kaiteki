import "package:flutter/material.dart";
import "package:kaiteki/di.dart";

class MissingDescriptionDialog extends StatelessWidget {
  const MissingDescriptionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.accessibility_new_rounded),
      title: const Text("Your attachment is missing a description"),
      content: const Text(
        "Descriptions allow users who are unable to see the attachment to understand what it is about.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.materialL10n.cancelButtonLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Post anyway"),
        ),
      ],
    );
  }
}
