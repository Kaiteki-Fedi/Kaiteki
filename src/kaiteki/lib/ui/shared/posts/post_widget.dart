import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/interfaces/bookmark_support.dart';
import 'package:kaiteki/fediverse/interfaces/favorite_support.dart';
import 'package:kaiteki/fediverse/interfaces/reaction_support.dart';
import 'package:kaiteki/fediverse/model/emoji/emoji.dart';
import 'package:kaiteki/fediverse/model/post/post.dart';
import 'package:kaiteki/theming/kaiteki/colors.dart';
import 'package:kaiteki/theming/kaiteki/post.dart';
import 'package:kaiteki/ui/debug/text_render_dialog.dart';
import 'package:kaiteki/ui/shared/emoji/emoji_selector_bottom_sheet.dart';
import 'package:kaiteki/ui/shared/posts/attachment_row.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';
import 'package:kaiteki/ui/shared/posts/embed_widget.dart';
import 'package:kaiteki/ui/shared/posts/embedded_post.dart';
import 'package:kaiteki/ui/shared/posts/interaction_bar.dart';
import 'package:kaiteki/ui/shared/posts/interaction_event_bar.dart';
import 'package:kaiteki/ui/shared/posts/meta_bar.dart';
import 'package:kaiteki/ui/shared/posts/poll_widget.dart';
import 'package:kaiteki/ui/shared/posts/reaction_row.dart';
import 'package:kaiteki/ui/shared/posts/reply_bar.dart';
import 'package:kaiteki/ui/shared/posts/subject_bar.dart';
import 'package:kaiteki/ui/shortcuts/activators.dart';
import 'package:kaiteki/ui/shortcuts/intents.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:kaiteki_material/kaiteki_material.dart';
import 'package:url_launcher/url_launcher.dart';

const kPostPadding = EdgeInsets.symmetric(vertical: 4.0);

class PostWidget extends ConsumerStatefulWidget {
  final Post post;
  final bool showParentPost;
  final bool showActions;
  final bool wide;
  final bool hideReplyee;
  final bool hideAvatar;
  final bool expand;

  /// onTap callback for content text
  final VoidCallback? onTap;

  const PostWidget(
    this.post, {
    super.key,
    this.showParentPost = true,
    this.showActions = true,
    this.wide = false,
    this.hideReplyee = false,
    this.hideAvatar = false,
    this.expand = false,
    this.onTap,
  });

  @override
  ConsumerState<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends ConsumerState<PostWidget> {
  late Post _post;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();

    if (_post.repeatOf != null) {
      return Column(
        children: [
          InkWell(
            onTap: () => context.showUser(_post.author, ref),
            child: InteractionEventBar(
              icon: Icons.repeat_rounded,
              text: l10n.postRepeated,
              color: Theme.of(context).ktkColors!.repeatColor,
              user: _post.author,
            ),
          ),
          PostWidget(
            _post.repeatOf!,
            showActions: widget.showActions,
            wide: widget.wide,
          ),
        ],
      );
    }

    final adapter = ref.watch(adapterProvider);
    const spacer = SizedBox(height: 8);

    final children = [
      MetaBar(
        post: _post,
        showAvatar: !widget.hideAvatar && widget.wide,
      ),
      if (widget.showParentPost && _post.replyToUser != null)
        ReplyBar(post: _post),
      PostContentWidget(
        post: _post,
        hideReplyee: widget.hideReplyee,
        onTap: widget.onTap,
      ),
      if (_post.embeds.isNotEmpty)
        Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              for (var embed in _post.embeds) EmbedWidget(embed),
            ].joinNonString(const Divider(height: 1)),
          ),
        ),
      if (_post.poll != null) ...[
        spacer,
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: PollWidget(_post.poll!, padding: const EdgeInsets.all(16)),
        ),
      ],
      if (_post.quotedPost != null) EmbeddedPostWidget(_post.quotedPost!),
      if (_post.attachments?.isNotEmpty == true) ...[
        spacer,
        AttachmentRow(post: _post),
      ],
      if (widget.expand && _post.client != null)
        Text(
          _post.client!,
          style: TextStyle(color: Theme.of(context).disabledColor),
        ),
      if (_post.reactions.isNotEmpty) ...[
        spacer,
        ReactionRow(_post.reactions, (r) => _onChangeReaction(r.emoji)),
      ],
      if (widget.showActions) ...[
        spacer,
        InteractionBar(
          metrics: _post.metrics,
          onReply: _onReply,
          onFavorite: _onFavorite,
          onRepeat: _onRepeat,
          onReact: _onReact,
          favorited: adapter is FavoriteSupport //
              ? _post.state.favorited
              : null,
          onShowFavoritees: () => context.pushNamed(
            "postFavorites",
            params: {...ref.accountRouterParams, "id": _post.id},
          ),
          onShowRepeatees: () => context.pushNamed(
            "postRepeats",
            params: {...ref.accountRouterParams, "id": _post.id},
          ),
          repeated: _post.state.repeated,
          reacted: adapter is ReactionSupport ? false : null,
          buildActions: _buildActions,
        )
      ],
    ];

    final theme = Theme.of(context).ktkPostTheme!;
    return FocusableActionDetector(
      shortcuts: const {
        reply: ReplyIntent(),
        repeat: RepeatIntent(),
        favorite: FavoriteIntent(),
        bookmark: BookmarkIntent(),
        // react: ReactIntent(),
        menu: MenuIntent(),
      },
      actions: {
        ReplyIntent: CallbackAction(onInvoke: (_) => _onReply),
        FavoriteIntent: CallbackAction(onInvoke: (_) => _onFavorite()),
        RepeatIntent: CallbackAction(onInvoke: (_) => _onRepeat()),
        BookmarkIntent: CallbackAction(onInvoke: (_) => _onBookmark()),
        ReactIntent: CallbackAction(onInvoke: (_) => _onReact()),
      },
      child: Padding(
        padding: theme.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.wide && !widget.hideAvatar) ...[
              AvatarWidget(
                _post.author,
                onTap: () => context.showUser(_post.author, ref),
              ),
              SizedBox(width: theme.avatarSpacing),
            ],
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            )
          ],
        ),
      ),
    );
  }

  List<PopupMenuEntry> _buildActions(BuildContext context) {
    final openInBrowserAvailable = _post.externalUrl != null;
    final l10n = context.getL10n();
    final adapter = ref.read(adapterProvider);

    return [
      if (adapter is BookmarkSupport)
        PopupMenuItem(
          value: _onBookmark,
          child: ListTile(
            title: Text(
              _post.state.bookmarked
                  ? l10n.postRemoveFromBookmarks
                  : l10n.postAddToBookmarks,
            ),
            leading: Icon(
              _post.state.bookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: Theme.of(context).ktkColors?.bookmarkColor ??
                  Colors.pink.harmonizeWith(
                    Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      const PopupMenuDivider(),
      PopupMenuItem(
        enabled: openInBrowserAvailable,
        child: ListTile(
          title: Text(l10n.openInBrowserLabel),
          leading: const Icon(Icons.open_in_new_rounded),
          contentPadding: EdgeInsets.zero,
          enabled: openInBrowserAvailable,
        ),
        value: () async {
          final url = _post.externalUrl;
          if (url == null) return;
          await launchUrl(url, mode: LaunchMode.externalApplication);
        },
      ),
      if (_post.content != null)
        PopupMenuItem(
          child: const ListTile(
            title: Text("Debug text rendering"),
            leading: Icon(Icons.bug_report_rounded),
            contentPadding: EdgeInsets.zero,
          ),
          value: () => showDialog(
            context: context,
            builder: (context) => TextRenderDialog(_post),
          ),
        ),
    ];
  }

  void _onReply() {
    context.pushNamed(
      "compose",
      params: ref.accountRouterParams,
      extra: _post,
    );
  }

  Future<void> _onFavorite() async {
    final adapter = ref.read(adapterProvider);
    final l10n = context.getL10n();
    try {
      final f = adapter as FavoriteSupport;
      final Post newPost;
      if (_post.state.favorited) {
        await f.unfavoritePost(_post.id);
        newPost = _post.copyWith.state(_post.state.copyWith.favorited(false));
      } else {
        await f.favoritePost(_post.id);
        newPost = _post.copyWith.state(_post.state.copyWith.favorited(true));
      }
      setState(() => _post = newPost);
    } catch (e, s) {
      context.showErrorSnackbar(
        text: Text(l10n.postFavoriteFailed),
        stackTrace: s,
        error: e,
      );
    }
  }

  Future<void> _onBookmark() async {
    final adapter = ref.read(adapterProvider);
    final l10n = context.getL10n();
    try {
      final f = adapter as BookmarkSupport;

      final Post newPost;
      if (_post.state.bookmarked) {
        await f.unbookmarkPost(_post.id);
        newPost = _post.copyWith.state(_post.state.copyWith.bookmarked(false));
      } else {
        await f.bookmarkPost(_post.id);
        newPost = _post.copyWith.state(_post.state.copyWith.bookmarked(false));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const TextInheritedIconTheme(child: Icon(Icons.check_rounded)),
                const SizedBox(width: 8),
                Text(
                  _post.state.bookmarked
                      ? l10n.postBookmarkRemoved
                      : l10n.postBookmarkAdded,
                ),
              ],
            ),
          ),
        );
      }

      setState(() => _post = newPost);
    } catch (e, s) {
      context.showErrorSnackbar(
        text: Text(l10n.postBookmarkFailed),
        stackTrace: s,
        error: e,
      );
    }
  }

  Future<void> _onRepeat() async {
    final adapter = ref.read(adapterProvider);
    final l10n = context.getL10n();
    try {
      final Post newPost;

      if (_post.state.repeated) {
        await adapter.unrepeatPost(_post.id);
        newPost = _post.copyWith.state(_post.state.copyWith.repeated(false));
      } else {
        await adapter.repeatPost(_post.id);
        newPost = _post.copyWith.state(_post.state.copyWith.repeated(true));
      }

      setState(() => _post = newPost);
    } catch (e, s) {
      context.showErrorSnackbar(
        text: Text(l10n.postRepeatFailed),
        stackTrace: s,
        error: e,
      );
    }
  }

  Future<void> _onChangeReaction(Emoji emoji) async {
    final messenger = ScaffoldMessenger.of(context);
    final account = ref.read(accountProvider)!;
    final adapter = account.adapter as ReactionSupport;

    try {
      final hasReacted = _post.reactions.any(
        (r) => r.includesMe && r.emoji == emoji,
      );

      final Post newPost;

      // TODO(Craftplacer): Make reaction methods return Post? and prefer server responses rather than client-side post mutations
      if (hasReacted) {
        await adapter.removeReaction(_post, emoji);
        newPost = _post.removeOrDeleteReaction(
          emoji,
          account.user,
        );
      } else {
        await adapter.addReaction(_post, emoji);
        newPost = _post.addOrCreateReaction(
          emoji,
          account.user,
          !adapter.capabilities.supportsMultipleReactions,
        );
      }

      setState(() => _post = newPost);
    } catch (e, s) {
      messenger.showSnackBar(
        SnackBar(
          content: const Text("Failed to react to post"),
          action: SnackBarAction(
            label: "Show details",
            onPressed: () {
              context.showExceptionDialog(e, s);
            },
          ),
        ),
      );
    }
  }

  Future<void> _onReact() async {
    final adapter = ref.read(adapterProvider) as ReactionSupport;
    final emoji = await showModalBottomSheet<Emoji?>(
      context: context,
      constraints: bottomSheetConstraints,
      builder: (_) => EmojiSelectorBottomSheet(
        showCustomEmojis: adapter.capabilities.supportsCustomEmojiReactions,
        showUnicodeEmojis: adapter.capabilities.supportsUnicodeEmojiReactions,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.0),
        ),
      ),
      elevation: 16.0,
      clipBehavior: Clip.antiAlias,
    );

    if (emoji == null) return;

    _onChangeReaction(emoji);
  }
}

class PostContentWidget extends ConsumerStatefulWidget {
  final Post post;
  final bool hideReplyee;
  final VoidCallback? onTap;

  const PostContentWidget({
    super.key,
    required this.post,
    required this.hideReplyee,
    this.onTap,
  });

  @override
  ConsumerState<PostContentWidget> createState() => _PostContentWidgetState();
}

class _PostContentWidgetState extends ConsumerState<PostContentWidget> {
  InlineSpan? renderedContent;
  bool collapsed = false;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    if (post.content != null) {
      renderedContent = post.renderContent(
        context,
        ref,
        hideReplyee: widget.hideReplyee,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (post.subject?.isNotEmpty == true)
          SubjectBar(
            subject: post.subject!,
            collapsed: collapsed,
            onTap: () => setState(() => collapsed = !collapsed),
          ),
        if (renderedContent != null &&
            renderedContent!.toPlainText().trim().isNotEmpty &&
            !collapsed)
          Padding(
            padding: kPostPadding,
            child: SelectableText.rich(
              TextSpan(children: [renderedContent!]),
              // FIXME(Craftplacer): https://github.com/flutter/flutter/issues/53797
              onTap: widget.onTap,
            ),
          ),
      ],
    );
  }
}
