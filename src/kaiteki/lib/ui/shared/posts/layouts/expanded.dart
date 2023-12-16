import "package:flutter/material.dart" hide Visibility;
import "package:intl/intl.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/theming/colors.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/posts/interaction_bar.dart";
import "package:kaiteki/ui/shared/posts/interaction_event_bar.dart";
import "package:kaiteki/ui/shared/posts/layouts/layout.dart";
import "package:kaiteki/ui/shared/posts/meta_bar.dart";
import "package:kaiteki/ui/shared/posts/post_content.dart";
import "package:kaiteki/ui/shared/posts/post_metrics_bar.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
import "package:kaiteki/ui/shared/posts/post_widget_theme.dart";
import "package:kaiteki/ui/shared/posts/reaction_row.dart";
import "package:kaiteki/ui/shared/posts/reply_bar.dart";
import "package:kaiteki/ui/shared/posts/signature.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";

class ExpandedPostLayout extends ConsumerWidget {
  final Post post;
  final InteractionCallbacks callbacks;
  final FocusNode? menuFocusNode;
  final VoidCallback? onOpen;
  final VoidCallback? onTap;
  final Function(Emoji emoji) onReact;

  const ExpandedPostLayout(
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
          PostWidget(
            repeatOf,
            layout: PostWidgetLayout.expanded,
            onOpen: onOpen,
            onTap: onTap,
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
          showVisibility: false,
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
            if (post.reactions.isNotEmpty &&
                ref.watch(showReactions).value) ...[
              const SizedBox(height: 8),
              ReactionRow(post.reactions, (r) => onReact(r.emoji)),
            ],
          ],
        ),
      ),
    ];

    final client = post.client;

    final mediumEmphasis =
        Theme.of(context).getEmphasisColor(EmphasisColor.medium);

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
          ContentColor(
            color: mediumEmphasis,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(height: 25),
                OverflowBar(
                  spacing: 16.0,
                  overflowSpacing: 8.0,
                  children: [
                    Text(
                      DateFormat.yMMMMd(
                        Localizations.localeOf(context).toString(),
                      ).add_jm().format(post.postedAt),
                    ),
                    if (post.visibility != null) _Visibility(post.visibility!),
                    if (client != null) Text(client),
                  ],
                ),
                const Divider(height: 25),
                PostMetricBar(post.metrics),
              ],
            ),
          ),
          if (postTheme?.showActions ?? true) ...[
            const Padding(
              padding: EdgeInsets.only(top: 12.0, bottom: 4.0),
              child: Divider(height: 1),
            ),
            Semantics(
              focusable: false,
              child: InteractionBar(
                metrics: post.metrics,
                callbacks: callbacks,
                showLabels: false,
                spread: true,
                favorited:
                    adapter is FavoriteSupport ? post.state.favorited : null,
                repeated: post.state.repeated,
                menuFocusNode: menuFocusNode,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Visibility extends StatelessWidget {
  const _Visibility(this.visibility);

  final PostScope visibility;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(visibility.toIconData(), size: 16),
        const SizedBox(width: 3.0),
        Text(visibility.toDisplayString(context.l10n)),
      ],
    );
  }
}
