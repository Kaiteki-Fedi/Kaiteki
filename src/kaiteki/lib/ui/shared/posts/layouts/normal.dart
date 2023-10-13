import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/theming/kaiteki/colors.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/ui/shared/posts/interaction_bar.dart";
import "package:kaiteki/ui/shared/posts/interaction_event_bar.dart";
import "package:kaiteki/ui/shared/posts/layouts/layout.dart";
import "package:kaiteki/ui/shared/posts/meta_bar.dart";
import "package:kaiteki/ui/shared/posts/post_content.dart";
import "package:kaiteki/ui/shared/posts/post_widget_theme.dart";
import "package:kaiteki/ui/shared/posts/reaction_row.dart";
import "package:kaiteki/ui/shared/posts/reply_bar.dart";
import "package:kaiteki/ui/shared/posts/signature.dart";
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
          NormalPostLayout(
            repeatOf,
            callbacks: callbacks,
            onReact: onReact,
            onOpen: onOpen,
            onTap: onTap,
            menuFocusNode: menuFocusNode,
          ),
        ],
      );
    }

    final adapter = ref.watch(adapterProvider);
    final showSignature = ref.watch(AppExperiment.userSignatures.provider) &&
        post.author.description?.isNotEmpty == true;

    const padding = EdgeInsets.all(8);

    final showParentPost = postTheme?.showParentPost ?? true;
    final children = [
      MetaBar(
        post: post,
        showAvatar: false,
        onOpen: ref.watch(showDedicatedPostOpenButton).value ? onOpen : null,
      ),
      Padding(
        padding: EdgeInsets.only(right: padding.right),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showParentPost && post.replyToUser != null)
              ReplyBar(post: post),
            PostContent(post: post, onTap: onTap),
            if (showSignature) PostSignature(post),
            if (post.reactions.isNotEmpty) ...[
              const SizedBox(height: 8),
              ReactionRow(post.reactions, (r) => onReact(r.emoji)),
            ],
          ],
        ),
      ),
    ];

    const leftPostContentInset = 8 + 48;

    return Padding(
      padding: padding.copyWith(
        bottom: 0.0,
        right: 0.0,
        top: 0.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (postTheme?.showAvatar ?? true) ...[
                Padding(
                  padding: EdgeInsets.only(top: padding.top),
                  child: AvatarWidget(
                    post.author,
                    onTap: showAuthor,
                    focusNode: FocusNode(skipTraversal: true),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              ),
            ],
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
