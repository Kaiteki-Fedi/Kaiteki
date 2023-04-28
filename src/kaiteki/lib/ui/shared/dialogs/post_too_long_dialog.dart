import "package:flutter/material.dart";

class PostTooLongDialog extends StatelessWidget {
  final int characterLimit;

  const PostTooLongDialog({required this.characterLimit, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.edit_note_rounded),
      title: const Text("Your post is too long"),
      content: Text(
        "The post exceeds the maximum length of $characterLimit characters",
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
