import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/text/rendering_extensions.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/ui/shared/posts/meta_bar.dart";
import "package:kaiteki_core/model.dart";
import "package:kaiteki_core/utils.dart";

class PostSuggestionListTile extends ConsumerWidget {
  const PostSuggestionListTile(this.post, {super.key, this.onTap});

  final Post post;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: onTap,
      leading: ExcludeSemantics(
        child: AvatarWidget(post.author, size: 40.0),
      ),
      title: Text.rich(
        post.author.renderDisplayName(context, ref),
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
      subtitle: Text.rich(
        post.renderContent(context, ref),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        locale: post.language?.andThen(Locale.new),
      ),
      trailing: PostTimestamp(post.postedAt),
    );
  }
}
