import 'package:flutter/material.dart';
import 'package:kaiteki/constants.dart' show dialogConstraints;
import 'package:kaiteki/di.dart';

import '../../dialogs/dialog_title_with_hero.dart';

class DiscardPostDialog extends StatelessWidget {
  const DiscardPostDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();
    return ConstrainedBox(
      constraints: dialogConstraints,
      child: AlertDialog(
        title: DialogTitleWithHero(
          icon: const Icon(Icons.delete),
          title: Text(l10n.discardDraftDialogTitle),
        ),
        content: Text(l10n.discardDraftDialogDescription),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Theme.of(context).colorScheme.error,
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
