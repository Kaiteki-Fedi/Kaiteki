import "package:flutter/material.dart" hide Visibility;
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/theming/kaiteki/colors.dart";
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
          WidePostLayout(
            repeatOf,
            onOpen: onOpen,
            callbacks: callbacks,
            onReact: onReact,
          ),
        ],
      );
    }

    final adapter = ref.watch(adapterProvider);
    final postTheme = PostWidgetTheme.of(context);
    const padding = EdgeInsets.all(8);

    final showSignature = ref.watch(AppExperiment.userSignatures.provider) &&
        post.author.description?.isNotEmpty == true;
    final children = [
      InkWell(
        onTap: () => context.showUser(post.author, ref),
        child: MetaBar(
          post: post,
          twolineAuthor: true,
          onOpen: ref.watch(showDedicatedPostOpenButton).value ? onOpen : null,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(right: padding.right),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (postTheme?.showParentPost ?? true && post.replyToUser != null)
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

    return Padding(
      padding: padding.copyWith(bottom: 0.0, right: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
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
      ),
    );
  }
}
