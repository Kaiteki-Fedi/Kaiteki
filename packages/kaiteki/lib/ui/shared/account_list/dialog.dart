import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/ui/shared/account_list/list_tile.dart";
import "package:kaiteki/ui/shared/dialogs/account_removal_dialog.dart";
import "package:kaiteki/ui/shared/dialogs/dynamic_dialog_container.dart";
import "package:kaiteki/utils/extensions.dart";

class AccountListDialog extends ConsumerWidget {
  const AccountListDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DynamicDialogContainer(
      builder: (context, fullscreen) {
        final accounts = ref.watch(accountManagerProvider).accounts;
        final currentAccount = ref.watch(currentAccountProvider);
        final l10n = context.l10n;

        final unselectedAccounts =
            accounts.whereNot((e) => e.key == currentAccount?.key);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(l10n.manageAccountsTitle),
              forceMaterialTransparency: true,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (currentAccount != null) ...[
                      SizedBox(
                        height: 48,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Signed in as",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ),
                      ),
                      AccountListTile(
                        account: currentAccount,
                        selected: true,
                        onTap: () => context.showUser(currentAccount.user, ref),
                        trailing: buildMenuAnchor(context, ref, currentAccount),
                      ),
                      if (unselectedAccounts.isNotEmpty) const Divider(),
                    ],
                    for (final account in unselectedAccounts)
                      AccountListTile(
                        account: account,
                        selected: currentAccount == account,
                        onTap: () => _switchAccount(context, account),
                        trailing: buildMenuAnchor(context, ref, account),
                      ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FilledButton.icon(
                        onPressed: () => onTapAdd(context),
                        icon: const Icon(Icons.add_rounded),
                        label: Text(l10n.addAccountButtonLabel),
                        style: FilledButton.styleFrom(
                          visualDensity: VisualDensity.comfortable,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  MenuAnchor buildMenuAnchor(
    BuildContext context,
    WidgetRef ref,
    Account account,
  ) {
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.logout_rounded),
          child: const Text("Sign out"),
          onPressed: () => _onSignOut(context, ref, account),
        ),
      ],
      builder: (context, controller, child) {
        return IconButton(
          icon: Icon(Icons.adaptive.more_rounded),
          onPressed: controller.open,
        );
      },
    );
  }

  void _switchAccount(BuildContext context, Account account) {
    Navigator.of(context).pop();
    context.goNamed(
      "home",
      pathParameters: {
        "accountUsername": account.key.username,
        "accountHost": account.key.host,
      },
    );
  }

  void onTapAdd(BuildContext context) => context.pushReplacementNamed("login");

  Future<void> _onSignOut(
    BuildContext context,
    WidgetRef ref,
    Account account,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AccountRemovalDialog(account: account),
    );

    if (result != true) return;

    await ref.read(accountManagerProvider.notifier).remove(account);
  }
}
