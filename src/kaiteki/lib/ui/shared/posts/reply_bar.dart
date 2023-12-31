import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/user_resolver.dart";
import "package:kaiteki/theming/text_theme.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/model.dart";
import "package:kaiteki_core/utils.dart";

class ReplyBar extends ConsumerWidget {
  const ReplyBar({
    super.key,
    this.textStyle,
    required this.post,
    this.onTap,
  });

  final VoidCallback? onTap;
  final TextStyle? textStyle;
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disabledColor = Theme.of(context).disabledColor;
    final l10n = context.l10n;
    final userTextStyle = Theme.of(context).ktkTextTheme?.linkTextStyle ??
        DefaultKaitekiTextTheme(context).linkTextStyle;

    final reference = UserReference(_getUserId());

    return Padding(
      padding: kPostPadding,
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: onTap,
        child: FutureBuilder<ResolveUserResult?>(
          future: ref.watch(
            resolveProvider(
              ref.watch(currentAccountProvider)!.key,
              reference,
            ).future,
          ),
          builder: (context, snapshot) {
            final result = snapshot.data;
            final span = result is ResolvedInternalUser
                ? result.user.renderDisplayName(context, ref)
                : TextSpan(text: _getText());

            return Text.rich(
              TextSpan(
                style: userTextStyle,
                children: [
                  // TODO(Craftplacer): refactor the following widget pattern to a future "IconSpan"
                  WidgetSpan(
                    child: Directionality(
                      textDirection: Directionality.of(context).inverted,
                      child: Icon(
                        Icons.reply_rounded,
                        size: DefaultTextStyle.of(context)
                            .style
                            .fontSize
                            .nullTransform((size) => size * 1.25),
                        color: disabledColor,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: " ${l10n.replyTo} ",
                    style: TextStyle(color: disabledColor),
                  ),
                  span,
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _getText() {
    final reference = post.replyToUser;

    if (reference == null) return "unknown user";

    final user = reference.data;
    if (user != null) return "@${user.username}";

    return reference.id;
  }

  String _getUserId() {
    final authorId = post.replyToUser?.id;
    if (authorId != null) return authorId;

    final authorIdFromPost = post.replyTo?.data?.author.id;
    if (authorIdFromPost != null) return authorIdFromPost;

    throw Exception("Can't find user id as reply");
  }
}
