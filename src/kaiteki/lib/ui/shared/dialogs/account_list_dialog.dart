import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/instance_prober.dart';
import 'package:kaiteki/model/auth/account.dart';
import 'package:kaiteki/ui/shared/dialogs/account_removal_dialog.dart';
import 'package:kaiteki/ui/shared/dialogs/dynamic_dialog_container.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';

class AccountListDialog extends ConsumerWidget {
  const AccountListDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DynamicDialogContainer(
      builder: (context, fullscreen) {
        final manager = ref.watch(accountManagerProvider);
        final currentAccount = ref.watch(accountProvider);
        final l10n = context.l10n;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(l10n.manageAccountsTitle),
              backgroundColor: Colors.transparent,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              elevation: 0,
            ),
            Column(
              children: [
                for (final account in manager.accounts)
                  AccountListTile(
                    account: account,
                    selected: currentAccount == account,
                    onSelect: () {
                      Navigator.of(context).pop();
                      context.goNamed(
                        "home",
                        params: {
                          "accountUsername": account.key.username,
                          "accountHost": account.key.host,
                        },
                      );
                    },
                    onSignOut: () async {
                      final result = await showDialog<bool>(
                        context: context,
                        builder: (context) => AccountRemovalDialog(
                          account: account,
                        ),
                      );

                      if (result == true) manager.remove(account);
                    },
                    showInstanceIcon: true,
                  ),
                const Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).disabledColor,
                    foregroundColor: Colors.white,
                    radius: 22,
                    child: const Icon(Icons.add_rounded),
                  ),
                  title: Text(l10n.addAccountButtonLabel),
                  onTap: () => onTapAdd(context),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ],
        );
      },
    );
  }

  void onTapAdd(BuildContext context) => context.pushReplacementNamed("login");
}

class AccountListTile extends ConsumerWidget {
  final Account account;
  final bool selected;
  final bool showInstanceIcon;
  final VoidCallback? onSelect;
  final VoidCallback? onSignOut;

  const AccountListTile({
    super.key,
    required this.account,
    this.selected = false,
    this.showInstanceIcon = false,
    this.onSelect,
    this.onSignOut,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      selected: selected,
      leading: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0, bottom: 4.0),
            child: AvatarWidget(
              account.user,
              size: 40,
            ),
          ),
          if (showInstanceIcon)
            Positioned(
              right: 0,
              bottom: 0,
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                type: MaterialType.circle,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: IconTheme(
                    data: IconThemeData(
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    child: InstanceIcon(account.key.host),
                  ),
                ),
              ),
            )
        ],
      ),
      title: Text(account.key.username),
      subtitle: Text(account.key.host),
      onTap: onSelect,
      trailing: onSignOut != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 24,
                  child: VerticalDivider(width: 15),
                ),
                IconButton(
                  icon: const Icon(Icons.logout_rounded),
                  onPressed: onSignOut,
                  splashRadius: 24,
                  tooltip: "Remove account",
                ),
              ],
            )
          : null,
    );
  }
}

class InstanceIcon extends ConsumerWidget {
  final String host;
  final double? size;

  const InstanceIcon(this.host, {super.key, this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = this.size ?? IconTheme.of(context).size;
    final value = ref.watch(probeInstanceProvider(host));

    return value.when(
      data: (result) {
        final iconUrl = result.instance?.iconUrl;
        if (iconUrl == null) return _buildFallback();
        return Image.network(
          iconUrl,
          width: size,
          height: size,
          cacheHeight: size?.ceil(),
          cacheWidth: size?.ceil(),
          errorBuilder: (_, __, ___) => _buildFallback(),
          loadingBuilder: (_, child, event) =>
              event == null ? child : _buildFallback(),
        );
      },
      error: (_, __) => _buildFallback(),
      loading: _buildFallback,
    );
  }

  Widget _buildFallback() => Icon(Icons.public_rounded, size: size);
}
