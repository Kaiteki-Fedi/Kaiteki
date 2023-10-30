import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/posts/attachment_row.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/ui/shared/users/user_display_name_widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/model.dart";

class EmbeddedPostWidget extends ConsumerWidget {
  final Post post;

  const EmbeddedPostWidget(this.post, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.outline),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: InkWell(
        onTap: () => context.showPost(post, ref),
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
              if (post.content != null) ...[
                const SizedBox(height: 8),
                Text.rich(post.renderContent(context, ref)),
              ],
              if (post.attachments?.isNotEmpty == true)
                AttachmentRow(post: post),
            ],
          ),
        ),
      ),
    );
  }
}
