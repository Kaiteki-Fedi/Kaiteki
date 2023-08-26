import "dart:convert";

import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/ui/auth/login/login_screen.dart";
import "package:kaiteki/ui/auth/transit_account.dart";
import "package:kaiteki/ui/shared/account_list/list_tile.dart";
import "package:kaiteki/ui/shared/dialogs/account_removal_dialog.dart";
import "package:kaiteki/ui/shared/dialogs/dynamic_dialog_container.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:qr_flutter/qr_flutter.dart";

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
                  children: [
                    if (currentAccount != null) ...[
                      AccountListTile(
                        account: currentAccount,
                        selected: true,
                        onSelect: () =>
                            context.showUser(currentAccount.user, ref),
                        onSignOut: () =>
                            _onSignOut(context, ref, currentAccount),
                        onHandoff: () =>
                            _onHandoff(context, ref, currentAccount),
                        showInstanceIcon: true,
                      ),
                      const Divider(),
                    ],
                    for (final account in unselectedAccounts)
                      AccountListTile(
                        account: account,
                        selected: currentAccount == account,
                        onSelect: () => _switchAccount(context, account),
                        onSignOut: () => _onSignOut(context, ref, account),
                        onHandoff: () => _onHandoff(context, ref, account),
                        showInstanceIcon: true,
                      ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.outlineVariant,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSurface,
                        radius: 22,
                        child: const Icon(Icons.add_rounded),
                      ),
                      title: Text(l10n.addAccountButtonLabel),
                      onTap: () => onTapAdd(context),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
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

  Future<void> _onHandoff(
    BuildContext context,
    WidgetRef ref,
    Account account,
  ) async {
    await Navigator.of(context).push<Account?>(
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          popOnly: true,
          prefillCredentials: PrefillCredentials(instance: account.key.host),
        ),
      ),
    );

    // ignore: use_build_context_synchronously
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  AppBar(
                    title: const Text("Sign in another device"),
                    forceMaterialTransparency: true,
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Scan this QR code with the other device",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  QrImageView(
                    data: jsonEncode(
                      TransitAccount.fromAccount(account).toJson(),
                    ),
                    eyeStyle: QrEyeStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      eyeShape: QrEyeShape.square,
                    ),
                    dataModuleStyle: QrDataModuleStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      dataModuleShape: QrDataModuleShape.square,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
