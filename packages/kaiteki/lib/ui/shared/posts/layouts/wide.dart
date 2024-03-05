import "package:flutter/material.dart" hide Visibility;
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

class WidePostLayout extends ConsumerWidget {
  final Post post;
  final InteractionCallbacks callbacks;
  final FocusNode? menuFocusNode;
  final VoidCallback? onOpen;
  final VoidCallback? onTap;
  final Function(Emoji emoji) onReact;

  const WidePostLayout(
    this.post, {
    super.key,
    required this.callbacks,
    this.menuFocusNode,
    this.onOpen,
    this.onTap,
    required this.onReact,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    final repeatOf = post.repeatOf;
    if (repeatOf != null) {
      final repeatColor = Theme.of(context).ktkColors?.repeatColor ??
          DefaultKaitekiColors(context).repeatColor;
      return Column(
        children: [
          InkWell(
            onTap: () => context.showUser(post.author, ref),
            child: InteractionEventBar(
              icon: Icons.repeat_rounded,
              text: l10n.postRepeated,
              color: repeatColor,
              user: post.author,
            ),
          ),
          const Divider(),
          PostWidget(
            repeatOf,
            onOpen: onOpen,
            onTap: onTap,
            layout: PostWidgetLayout.wide,
            useCard: false,
          ),
        ],
      );
    }

    final adapter = ref.watch(adapterProvider);
    final postTheme = PostWidgetTheme.of(context);
    const padding = EdgeInsets.all(8);

    final children = [
      InkWell(
        onTap: () => context.showUser(post.author, ref),
        customBorder: const StadiumBorder(),
        child: Row(
          children: [
            AvatarWidget(post.author, size: 40.0),
            const SizedBox(width: 8.0),
            Expanded(
              child: MetaBar(
                post: post,
                twolineAuthor: true,
                onOpen: ref.watch(showDedicatedPostOpenButton).value
                    ? onOpen
                    : null,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8.0),
      Padding(
        padding: EdgeInsets.only(right: padding.right),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (postTheme?.showParentPost ?? true && post.replyToUser != null)
              ReplyBar(post: post),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding.copyWith(bottom: 0.0, right: 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
        if (postTheme?.showActions ?? true)
          Semantics(
            focusable: false,
            child: InteractionBar(
              metrics: post.metrics,
              callbacks: callbacks,
              favorited:
                  adapter is FavoriteSupport ? post.state.favorited : null,
              repeated: post.state.repeated,
              menuFocusNode: menuFocusNode,
            ),
          ),
      ],
    );
  }
}
