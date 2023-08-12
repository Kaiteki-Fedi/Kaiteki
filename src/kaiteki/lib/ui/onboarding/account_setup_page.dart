import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/account_list/list_tile.dart";

class AccountSetupPage extends ConsumerWidget {
  const AccountSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountManager = ref.watch(accountManagerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: accountManager.accounts.length,
            itemBuilder: (context, index) {
              final compound = accountManager.accounts.elementAt(index);
              return AccountListTile(account: compound);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: () => context.pushNamed("login"),
            icon: const Icon(Icons.add_rounded),
            label: const Text("Add Account"),
          ),
        ),
      ],
    );
  }
}
