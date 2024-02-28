import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/ui/shared/account_list/list_tile.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/dialogs/account_removal_dialog.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";

class AccountListDialog extends ConsumerStatefulWidget {
  const AccountListDialog({super.key});

  @override
  ConsumerState<AccountListDialog> createState() => _AccountListDialogState();
}

class _AccountListDialogState extends ConsumerState<AccountListDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bottomSheetAnimationController;

  @override
  void initState() {
    super.initState();
    _bottomSheetAnimationController =
        BottomSheet.createAnimationController(this);
  }

  @override
  void dispose() {
    _bottomSheetAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    if (WindowWidthSizeClass.fromContext(context) <=
        WindowWidthSizeClass.compact) {
      return BottomSheet(
        animationController: _bottomSheetAnimationController,
        builder: (_) => _AccountListBody(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                l10n.manageAccountsTitle,
                style: theme.textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
        onClosing: () {},
      );
    }

    return Dialog(
      child: ConstrainedBox(
        constraints: kDialogConstraints,
        child: _AccountListBody(
          children: [
            AppBar(
              title: Text(l10n.manageAccountsTitle),
              forceMaterialTransparency: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountListBody extends ConsumerWidget {
  final List<Widget> children;

  const _AccountListBody({this.children = const []});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountManagerProvider).accounts;
    final currentAccount = ref.watch(currentAccountProvider);
    final l10n = context.l10n;

    final unselectedAccounts =
        accounts.whereNot((e) => e.key == currentAccount?.key);

    final theme = Theme.of(context);
    const divider = Divider(height: 1.0 + 8.0 * 2);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...children,
          if (currentAccount != null) ...[
            SizedBox(
              height: 48,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Signed in as",
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ),
            ),
            AccountListTile(
              account: currentAccount,
              // selected: true,
              onTap: () => _viewCurrentProfile(context, ref, currentAccount.user),
              trailing: buildMenuAnchor(context, ref, currentAccount),
            ),
            if (unselectedAccounts.isNotEmpty) divider,
          ],
          ...unselectedAccounts.map<Widget>((e) {
            return AccountListTile(
              account: e,
              // selected: currentAccount == e,
              onTap: () => _switchAccount(context, e),
              trailing: buildMenuAnchor(context, ref, e),
            );
          }),
          ListTile(
            leading: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.person_add_alt_1_rounded),
            ),
            title: Text(l10n.addAccountButtonLabel),
            onTap: () => onTapAdd(context),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
  void _viewCurrentProfile(BuildContext context, WidgetRef ref, User user) {
    Navigator.of(context).pop();
    context.pushNamed(
      "user",
      pathParameters: {
        ...ref.accountRouterParams,
        "id": user.id,
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
