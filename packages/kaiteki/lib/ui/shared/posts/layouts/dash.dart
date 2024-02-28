import "package:collection/collection.dart";
import "package:flutter/material.dart" hide Visibility;
import "package:intl/intl.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/theming/colors.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/ui/shared/posts/layouts/callbacks.dart";
import "package:kaiteki/ui/shared/posts/meta_bar.dart";
import "package:kaiteki/ui/shared/posts/post_content.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
import "package:kaiteki/ui/shared/posts/post_widget_theme.dart";
import "package:kaiteki/ui/shared/posts/reaction_row.dart";
import "package:kaiteki/ui/shared/posts/reply_bar.dart";
import "package:kaiteki/ui/shared/posts/user_badge.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki/utils/pronouns.dart";
import "package:kaiteki_core/social.dart";
import "package:kaiteki_core/utils.dart";

class DashPostLayout extends ConsumerStatefulWidget {
  final Post post;
  final InteractionCallbacks callbacks;
  final FocusNode? menuFocusNode;
  final VoidCallback? onOpen;
  final VoidCallback? onTap;
  final Function(Emoji emoji) onReact;

  const DashPostLayout(
    this.post, {
    super.key,
    required this.callbacks,
    this.menuFocusNode,
    this.onOpen,
    this.onTap,
    required this.onReact,
  });

  @override
  ConsumerState<DashPostLayout> createState() => _DashPostLayoutState();
}

class _DashPostLayoutState extends ConsumerState<DashPostLayout> {
  bool _showInteractions = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const padding = EdgeInsets.all(8);

    final repeatOf = widget.post.repeatOf;
    if (repeatOf != null) {
      return Column(
        children: [
          InkWell(
            onTap: () => context.showUser(widget.post.author, ref),
            child: Padding(
              padding: padding,
              child: DashMetaBar(widget.post, isRepeat: true),
            ),
          ),
          const Divider(),
          PostWidget(
            repeatOf,
            onOpen: widget.onOpen,
            onTap: widget.onTap,
            layout: PostWidgetLayout.dash,
          ),
        ],
      );
    }

    final adapter = ref.watch(adapterProvider);
    final postTheme = PostWidgetTheme.of(context);

    final children = [
      InkWell(
        onTap: () => context.showUser(widget.post.author, ref),
        child: Padding(
          padding: padding,
          child: DashMetaBar(widget.post),
        ),
      ),
      Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (postTheme?.showParentPost ??
                true && widget.post.replyToUser != null)
              ReplyBar(post: widget.post),
            PostContent(post: widget.post, onTap: widget.onTap),
            if (widget.post.reactions.isNotEmpty &&
                ref.watch(showReactions).value) ...[
              const SizedBox(height: 8),
              ReactionRow(
                widget.post.reactions,
                (r) => widget.onReact(r.emoji),
              ),
            ],
          ],
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...children,
        if (postTheme?.showActions ?? true)
          Semantics(
            focusable: false,
            child: Column(
              children: [
                const SizedBox(height: 8),
                const Divider(indent: 8, endIndent: 8),
                DashInteractionBar(
                  metrics: widget.post.metrics,
                  callbacks: widget.callbacks,
                  state: widget.post.state,
                  onToggleInteractions: () {
                    setState(() => _showInteractions = !_showInteractions);
                  },
                ),
                if (_showInteractions)
                  DashInteractionList(
                    metrics: widget.post.metrics,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class DashInteractionBar extends StatelessWidget {
  final PostState state;
  final PostMetrics metrics;
  final InteractionCallbacks callbacks;
  final VoidCallback onToggleInteractions;

  const DashInteractionBar({
    super.key,
    required this.state,
    required this.metrics,
    required this.onToggleInteractions,
    required this.callbacks,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.ktkColors;

    final interactionCount =
        metrics.favoriteCount + metrics.repeatCount + metrics.replyCount;
    final numFormat = NumberFormat.compact();

    return Row(
      children: [
        TextButton(
          onPressed: onToggleInteractions,
          child: Text("See ${numFormat.format(interactionCount)} interactions"),
        ),
        const Spacer(),
        if (callbacks.onReply is! UnavailableInteractionCallback)
          IconButton(
            icon: const Icon(Icons.reply_rounded),
            onPressed: callbacks.onReply.callback,
          ),
        if (callbacks.onRepeat is! UnavailableInteractionCallback)
          IconButton(
            icon: const Icon(Icons.repeat_rounded),
            color: state.repeated ? colors?.repeatColor : null,
            onPressed: callbacks.onRepeat.callback,
          ),
        if (callbacks.onFavorite is! UnavailableInteractionCallback)
          IconButton(
            icon: const Icon(Icons.star_rounded),
            color: state.favorited ? colors?.favoriteColor : null,
            onPressed: callbacks.onFavorite.callback,
          ),
      ],
    );
  }
}

class DashInteractionList extends StatefulWidget {
  final PostMetrics? metrics;

  const DashInteractionList({super.key, this.metrics});

  @override
  State<DashInteractionList> createState() => _DashInteractionListState();
}

class _DashInteractionListState extends State<DashInteractionList> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar.secondary(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: [
              Tab(
                child: Row(
                  children: [
                    const Icon(Icons.reply_rounded),
                    const SizedBox(width: 8),
                    Text(widget.metrics?.replyCount.toString() ?? "Replies"),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    const Icon(Icons.repeat_rounded),
                    const SizedBox(width: 8),
                    Text(widget.metrics?.repeatCount.toString() ?? "Repeats"),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded),
                    const SizedBox(width: 8),
                    Text(widget.metrics?.favoriteCount.toString() ??
                        "Favorites"),
                  ],
                ),
              ),
            ],
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 600),
            child: const TabBarView(
              children: [
                Placeholder(),
                Placeholder(),
                Placeholder(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashMetaBar extends ConsumerWidget {
  final Post post;
  final bool isRepeat;

  const DashMetaBar(this.post, {super.key, this.isRepeat = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final author = post.author;
    final isAdministrator = author.flags?.isAdministrator ?? false;
    final isModerator = author.flags?.isModerator ?? false;
    final isBot = author.type == UserType.bot;

    var pronouns;

    if (ref.watch(highlightPronouns).value) {
      pronouns = author.details.fields
          ?.firstWhereOrNull(
            (e) => kPronounsFieldKeys.contains(e.key.trim().toLowerCase()),
          )
          ?.value
          .andThen(parsePronouns);
    }

    return IconTheme(
      data: const IconThemeData(size: 18),
      child: Row(
        children: [
          AvatarWidget(
            author,
            size: 40,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      author.handle.toString(),
                      style: theme.textTheme.titleSmall,
                    ),
                    if (isRepeat) const Text("reblogged"),
                    if (pronouns != null && pronouns.isNotEmpty)
                      PronounBadge(pronouns: pronouns),
                    if (ref.watch(showUserBadges).value) ...[
                      if (isAdministrator)
                        const UserBadge(type: UserBadgeType.administrator)
                      else if (isModerator)
                        const UserBadge(type: UserBadgeType.moderator),
                      if (isBot) const UserBadge(type: UserBadgeType.bot),
                    ],
                  ].spacedHorizontally(8),
                ),
                DefaultTextStyle.merge(
                  style: theme.textTheme.labelMedium,
                  child: Row(
                    children: [
                      PostTimestamp(post.postedAt),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
