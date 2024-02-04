import "package:flutter/material.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/ui/shared/account_list/list_tile.dart";

class AccountDeletionConfirmationPage extends StatelessWidget {
  final Account account;

  const AccountDeletionConfirmationPage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "You are about to delete the following account. This action is irreversible and cannot be undone.",
        ),
        AccountListTile(account: account),
      ],
    );
  }
}
