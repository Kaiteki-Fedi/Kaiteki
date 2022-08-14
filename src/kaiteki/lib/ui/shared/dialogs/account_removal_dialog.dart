import 'package:flutter/material.dart';
import 'package:kaiteki/constants.dart' show dialogConstraints;
import 'package:kaiteki/di.dart';
import 'package:kaiteki/ui/shared/dialogs/dialog_title_with_hero.dart';

class AccountRemovalDialog extends StatelessWidget {
  const AccountRemovalDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();

    return ConstrainedBox(
      constraints: dialogConstraints,
      child: AlertDialog(
        title: DialogTitleWithHero(
          icon: const Icon(Icons.logout_rounded),
          title: Text(l10n.accountRemovalConfirmationTitle),
        ),
        content: Text(l10n.accountRemovalConfirmationDescription),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancelButtonLabel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Theme.of(context).errorColor,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.removeButtonLabel),
          )
        ],
      ),
    );
  }
}
