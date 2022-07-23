import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/ui/shared/dialogs/account_list_dialog.dart';

class AccountSetupPage extends ConsumerWidget {
  const AccountSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.watch(accountProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: manager.accounts.length,
            itemBuilder: (context, index) {
              final compound = manager.accounts.elementAt(index);
              return AccountListTile(account: compound);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: () => context.push("/login"),
            icon: const Icon(Icons.add_rounded),
            label: const Text("Add Account"),
          ),
        ),
      ],
    );
  }
}
