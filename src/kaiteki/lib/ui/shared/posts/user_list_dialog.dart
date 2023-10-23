import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/dialogs/dynamic_dialog_container.dart";
import "package:kaiteki/ui/shared/error_landing_widget.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/ui/shared/users/user_display_name_widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";
import "package:kaiteki_core/utils.dart";

class UserListDialog extends StatelessWidget {
  final Widget title;
  final Future<List<User>> fetchUsers;
  final Icon emptyIcon;
  final Text emptyTitle;

  const UserListDialog({
    super.key,
    required this.title,
    required this.fetchUsers,
    required this.emptyIcon,
    required this.emptyTitle,
  });

  @override
  Widget build(BuildContext context) {
    return DynamicDialogContainer(
      builder: (context, fullscreen) {
        return Column(
          children: [
            AppBar(title: title),
            Flexible(
              child: FutureBuilder<List<User>>(
                future: fetchUsers,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: ErrorLandingWidget.fromAsyncSnapshot(snapshot),
                    );
                  }

                  if (!snapshot.hasData) {
                    return centeredCircularProgressIndicator;
                  }

                  final users = snapshot.data!;
                  if (users.isEmpty) return _buildEmptyState();
                  return _buildList(users);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildList(List<User> users) {
    return Consumer(
      builder: (context, ref, _) {
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, i) => UserListTile(
            user: users[i],
            onPressed: () => context.showUser(users[i], ref),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: IconLandingWidget(
        icon: emptyIcon,
        text: emptyTitle,
      ),
    );
  }
}

class UserListTile extends ConsumerWidget {
  const UserListTile({
    super.key,
    required this.user,
    this.onPressed,
    this.showDescription = true,
    this.trailing = const [],
    this.content = const [],
    this.avatarSize = 32.0,
    this.titleAlignment,
  });

  final User user;
  final VoidCallback? onPressed;
  final List<Widget> trailing;
  final bool showDescription;
  final List<Widget> content;
  final double avatarSize;
  final ListTileTitleAlignment? titleAlignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final description = user.description?.trim();
    final hasDescription = description != null && description.isNotEmpty;

    final subtitle = [
      if (hasDescription && showDescription)
        Text.rich(
          user.renderText(context, ref, description),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      if (content.isNotEmpty) ...content,
    ];

    return ListTile(
      onTap: onPressed,
      title: UserDisplayNameWidget(user),
      leading: AvatarWidget(user, size: avatarSize),
      titleAlignment: titleAlignment ?? ListTileTitleAlignment.top,
      subtitle: subtitle.isNotEmpty ? Column(children: subtitle) : null,
      trailing: trailing.nullTransform(
        (e) => Row(
          mainAxisSize: MainAxisSize.min,
          children: e,
        ),
      ),
    );
  }
}
