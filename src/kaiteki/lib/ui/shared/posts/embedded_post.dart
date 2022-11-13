import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/ui/shared/posts/attachment_row.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';
import 'package:kaiteki/ui/shared/posts/user_display_name_widget.dart';
import 'package:kaiteki/utils/extensions.dart';

class EmbeddedPostWidget extends ConsumerWidget {
  final Post post;

  const EmbeddedPostWidget(this.post, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openPost(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AvatarWidget(
                    post.author,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: UserDisplayNameWidget(post.author)),
                ],
              ),
              const SizedBox(height: 8),
              Text.rich(post.renderContent(context, ref)),
              if (post.attachments?.isNotEmpty == true)
                AttachmentRow(post: post),
            ],
          ),
        ),
      ),
    );
  }

  void openPost(BuildContext context, WidgetRef ref) {
    final account = ref.read(accountProvider).currentAccount;
    final instance = account.key.host;
    final username = account.key.username;
    context.push(
      "/@$username@$instance/posts/${post.id}",
      extra: post,
    );
  }
}
