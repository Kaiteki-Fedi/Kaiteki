import "package:flutter/material.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/account_list/list_tile.dart";

class ChooseAccountDialog extends ConsumerWidget {
  const ChooseAccountDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountManagerProvider).accounts;
    return AlertDialog(
      contentPadding: const EdgeInsets.all(8.0),
      title: const Text("Choose account"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final account in accounts)
            AccountListTile(
              account: account,
              onSelect: () => Navigator.of(context).pop(account),
            ),
        ],
      ),
    );
  }
}
