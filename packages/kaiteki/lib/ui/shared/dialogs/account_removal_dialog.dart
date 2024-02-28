import "package:flutter/material.dart";
import "package:kaiteki/constants.dart" show kDialogConstraints;
import "package:kaiteki/di.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/utils/extensions.dart";

class AccountRemovalDialog extends ConsumerWidget {
  final Account account;

  const AccountRemovalDialog({super.key, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return AlertDialog(
      icon: const Icon(Icons.logout_rounded),
      title: Text(l10n.accountRemovalConfirmationTitle),
      content: SizedBox(
        width: kDialogConstraints.minWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.accountRemovalConfirmationDescription),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text.rich(
                  account.user.renderDisplayName(context, ref),
                ),
                subtitle: Text(account.key.host),
                leading: AvatarWidget(account.user),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        const CancelTextButton(),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.removeButtonLabel),
        ),
      ],
    );
  }
}
