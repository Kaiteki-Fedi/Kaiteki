import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/ui/shared/account_list/instance_icon.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";

class AccountListTile extends ConsumerWidget {
  final Account account;
  final bool selected;
  final bool showInstanceIcon;
  final VoidCallback? onSelect;
  final VoidCallback? onSignOut;
  final VoidCallback? onHandoff;

  const AccountListTile({
    super.key,
    required this.account,
    this.selected = false,
    this.showInstanceIcon = false,
    this.onSelect,
    this.onSignOut,
    this.onHandoff,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = [
      if (onSignOut != null)
        IconButton(
          icon: const Icon(Icons.logout_rounded),
          onPressed: onSignOut,
          splashRadius: 24,
          tooltip: "Remove account",
        ),
      if (onHandoff != null)
        IconButton(
          icon: const Icon(Icons.devices_rounded),
          onPressed: onHandoff,
          splashRadius: 24,
          tooltip: "Sign in on other device",
        ),
    ];

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
      trailing: actions.isNotEmpty
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 24,
                  child: VerticalDivider(width: 15),
                ),
                ...actions,
              ],
            )
          : null,
    );
  }
}
