import "package:flutter/material.dart";
import "package:kaiteki/di.dart";

class PostTooLongDialog extends StatelessWidget {
  final int characterLimit;

  const PostTooLongDialog({required this.characterLimit, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.edit_note_rounded),
      title: Text(context.l10n.postLengthExceededDialogTitle),
      content: Text(
        context.l10n.postLengthExceededDialogDescription(characterLimit),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }
}
