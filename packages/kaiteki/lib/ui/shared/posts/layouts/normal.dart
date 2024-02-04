import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/theming/colors.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/ui/shared/posts/interaction_bar.dart";
import "package:kaiteki/ui/shared/posts/interaction_event_bar.dart";
import "package:kaiteki/ui/shared/posts/layouts/callbacks.dart";
import "package:kaiteki/ui/shared/posts/meta_bar.dart";
import "package:kaiteki/ui/shared/posts/post_content.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
import "package:kaiteki/ui/shared/posts/post_widget_theme.dart";
import "package:kaiteki/ui/shared/posts/reaction_row.dart";
import "package:kaiteki/ui/shared/posts/reply_bar.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";

class NormalPostLayout extends ConsumerWidget {
  final Post post;
  final VoidCallback? onOpen;
  final VoidCallback? onTap;
  final InteractionCallbacks callbacks;
  final FocusNode? menuFocusNode;
  final Function(Emoji emoji) onReact;

  const NormalPostLayout(
    this.post, {
    super.key,
    required this.callbacks,
    this.onOpen,
    this.onTap,
    this.menuFocusNode,
    required this.onReact,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final postTheme = PostWidgetTheme.of(context);

    void showAuthor() => context.showUser(post.author, ref);

    final repeatColor = Theme.of(context).ktkColors?.repeatColor ??
        DefaultKaitekiColors(context).repeatColor;
    final repeatOf = post.repeatOf;
    if (repeatOf != null) {
      return Column(
        children: [
          InkWell(
            onTap: showAuthor,
            child: InteractionEventBar(
              icon: Icons.repeat_rounded,
              text: l10n.postRepeated,
              color: repeatColor,
              user: post.author,
            ),
          ),
          PostWidget(
            repeatOf,
            onOpen: onOpen,
            onTap: onTap,
          ),
        ],
      );
    }

    final adapter = ref.watch(adapterProvider);

    const padding = EdgeInsetsDirectional.all(8);

    final showParentPost = postTheme?.showParentPost ?? true;
    final children = [
      Padding(
        padding: EdgeInsetsDirectional.only(end: padding.end),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showParentPost &&
                (post.replyToUser != null || post.replyTo != null)) ...[
              ReplyBar(post: post),
              const SizedBox(height: 8),
            ],
            PostContent(post: post, onTap: onTap),
            if (post.reactions.isNotEmpty &&
                ref.watch(showReactions).value) ...[
              const SizedBox(height: 8),
              ReactionRow(post.reactions, (r) => onReact(r.emoji)),
            ],
          ],
        ),
      ),
    ];

    const leftPostContentInset = 8 + 48;

    final metaArea = Padding(
      padding: EdgeInsets.only(top: padding.top),
      child: Row(
        children: [
          if (postTheme?.showAvatar ?? true) ...[
            AvatarWidget(
              post.author,
              onTap: showAuthor,
              focusNode: FocusNode(skipTraversal: true),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: MetaBar(
              post: post,
              twolineAuthor: true,
              onOpen:
                  ref.watch(showDedicatedPostOpenButton).value ? onOpen : null,
            ),
          ),
        ],
      ),
    );
    return Padding(
      padding: padding.copyWith(
        bottom: 0.0,
        end: 0.0,
        top: 0.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          metaArea,
          const SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.only(left: leftPostContentInset.toDouble()),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
          if (postTheme?.showActions ?? true) ...[
            Semantics(
              focusable: false,
              child: Padding(
                padding: const EdgeInsets.only(left: leftPostContentInset - 8),
                child: InteractionBar(
                  metrics: post.metrics,
                  callbacks: callbacks,
                  favorited: adapter is FavoriteSupport //
                      ? post.state.favorited
                      : null,
                  repeated: post.state.repeated,
                  menuFocusNode: menuFocusNode,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
