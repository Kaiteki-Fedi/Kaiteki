import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/ui/shared/account_list/instance_icon.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";

class AccountListTile extends ConsumerWidget {
  final Account account;
  final bool selected;
  final bool showInstanceIcon;
  final VoidCallback? onTap;
  final Widget? trailing;

  const AccountListTile({
    super.key,
    required this.account,
    this.selected = false,
    this.showInstanceIcon = false,
    this.onTap,
    this.trailing,
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
            ),
        ],
      ),
      title: Text(account.key.username),
      subtitle: Text(account.key.host),
      onTap: onTap,
      trailing: trailing != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 24,
                  child: VerticalDivider(width: 15),
                ),
                trailing!,
              ],
            )
          : null,
    );
  }
}
