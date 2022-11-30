import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/instance_prober.dart';
import 'package:kaiteki/model/auth/account_compound.dart';
import 'package:kaiteki/ui/shared/dialogs/account_removal_dialog.dart';
import 'package:kaiteki/ui/shared/dialogs/dynamic_dialog_container.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';

class AccountListDialog extends ConsumerWidget {
  const AccountListDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DynamicDialogContainer(
      builder: (context, fullscreen) {
        final manager = ref.watch(accountProvider);
        final l10n = context.getL10n();

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
                for (final compound in manager.accounts)
                  AccountListTile(
                    account: compound,
                    selected: manager.current == compound,
                    onTap: () => Navigator.of(context).pop(),
                    showInstanceIcon: true,
                    enableSignOut: true,
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

  void onTapAdd(BuildContext context) => context.push("/login");
}

class AccountListTile extends ConsumerWidget {
  final Account account;
  final bool selected;
  final bool showInstanceIcon;
  final VoidCallback? onTap;
  final bool enableSignOut;

  const AccountListTile({
    super.key,
    required this.account,
    this.selected = false,
    this.showInstanceIcon = false,
    this.enableSignOut = false,
    this.onTap,
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
      onTap: () => _onSelect(ref),
      trailing: enableSignOut
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 24,
                  child: VerticalDivider(width: 15),
                ),
                IconButton(
                  icon: const Icon(Icons.logout_rounded),
                  onPressed: () => _onRemove(context, ref),
                  splashRadius: 24,
                  tooltip: "Remove account",
                ),
              ],
            )
          : null,
    );
  }

  Future<void> _onSelect(WidgetRef ref) async {
    ref.read(accountProvider).current = account;
    onTap?.call();
  }

  Future<void> _onRemove(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AccountRemovalDialog(
        account: account,
      ),
    );

    if (result == true) {
      ref.read(accountProvider).remove(account);
    }
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
