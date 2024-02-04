import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/model.dart";

class UserSuggestionListTile extends ConsumerWidget {
  final User user;
  final VoidCallback? onTap;

  const UserSuggestionListTile(this.user, {super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: AvatarWidget(user, size: 40.0),
      title: Text.rich(
        user.renderDisplayName(context, ref),
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
      subtitle: Text(
        user.handle.toString(),
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
      onTap: onTap,
    );
  }
}
