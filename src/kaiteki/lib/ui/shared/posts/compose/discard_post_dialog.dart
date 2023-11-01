import "package:flutter/material.dart";
import "package:kaiteki/constants.dart" show kDialogConstraints;
import "package:kaiteki/di.dart";

class DiscardPostDialog extends StatelessWidget {
  const DiscardPostDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ConstrainedBox(
      constraints: kDialogConstraints,
      child: AlertDialog(
        icon: const Icon(Icons.delete),
        title: Text(l10n.discardDraftDialogTitle),
        content: Text(l10n.discardDraftDialogDescription),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.discardButtonLabel),
          ),
          TextButton(
            child: Text(l10n.keepWritingButtonLabel),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
