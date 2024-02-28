import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/common.dart";

class MissingDescriptionDialog extends StatelessWidget {
  const MissingDescriptionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.accessibility_new_rounded),
      title: Text(context.l10n.missingDescriptionDialogTitle),
      content: Text(context.l10n.missingDescriptionDialogDescription),
      actions: [
        const CancelTextButton(),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(context.l10n.postAnywayButtonLabel),
        ),
      ],
    );
  }
}
