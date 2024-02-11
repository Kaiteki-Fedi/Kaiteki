import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/utils/extensions.dart";

class AccountListTile extends ConsumerWidget {
  final Account account;
  final VoidCallback? onTap;
  final Widget? trailing;

  const AccountListTile({
    super.key,
    required this.account,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: AvatarWidget(account.user, size: 40),
      title: Text.rich(
        account.user.renderDisplayName(context, ref),
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text("@${account.key.username}@${account.key.host}"),
      onTap: onTap,
      trailing: trailing,
    );
  }
}
