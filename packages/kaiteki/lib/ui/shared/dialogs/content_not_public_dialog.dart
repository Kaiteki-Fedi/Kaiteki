import "package:flutter/material.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/common.dart";

/// A dialog that shows up when the user tries to view a post or profile that
/// is probably not accessible externally (e.g. via a link).
class ContentNotPublicDialog extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const ContentNotPublicDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.lock_rounded),
      title: const Text("Content is not public"),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: kDialogConstraints.minWidth),
        child: const Text(
          "The link you are trying to open will take you to content that is not public, which may prevent you from being able to access it on the original page.",
        ),
      ),
      actions: [
        const CancelTextButton(),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(context.materialL10n.continueButtonLabel),
        ),
      ],
    );
  }
}
