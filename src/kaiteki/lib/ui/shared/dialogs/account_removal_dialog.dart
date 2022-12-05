import 'package:flutter/material.dart';
import 'package:kaiteki/constants.dart' show dialogConstraints;
import 'package:kaiteki/di.dart';
import 'package:kaiteki/model/auth/account.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';
import 'package:kaiteki/utils/extensions.dart';

class AccountRemovalDialog extends StatelessWidget {
  final Account? account;

  const AccountRemovalDialog({super.key, this.account});

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();

    return AlertDialog(
      icon: const Icon(Icons.logout_rounded),
      title: Text(l10n.accountRemovalConfirmationTitle),
      content: SizedBox(
        width: dialogConstraints.minWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.accountRemovalConfirmationDescription),
            if (account != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Consumer(
                  builder: (context, ref, _) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text.rich(
                        account!.user.renderDisplayName(context, ref),
                      ),
                      subtitle: Text(account!.key.host),
                      leading: AvatarWidget(account!.user),
                    );
                  },
                ),
              )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancelButtonLabel),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).errorColor,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.removeButtonLabel),
        )
      ],
    );
  }
}
