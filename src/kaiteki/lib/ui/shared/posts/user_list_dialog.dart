import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaiteki/fediverse/model/user/user.dart';
import 'package:kaiteki/ui/shared/dialogs/dynamic_dialog_container.dart';
import 'package:kaiteki/ui/shared/error_landing_widget.dart';
import 'package:kaiteki/ui/shared/icon_landing_widget.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';
import 'package:kaiteki/ui/shared/users/user_display_name_widget.dart';
import 'package:kaiteki/utils/extensions.dart';

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
                    return const Center(child: CircularProgressIndicator());
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
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (_, i) => UserListTile(user: users[i]),
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
  });

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final description = user.description?.trim();
    return InkWell(
      onTap: () => context.showUser(user, ref),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvatarWidget(user, size: 32),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 32,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: UserDisplayNameWidget(user),
                    ),
                  ),
                  if (description != null && description.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(height: 8),
                        Text.rich(
                          user.renderText(context, ref, description),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
