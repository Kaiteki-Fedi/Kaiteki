import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/interfaces/bookmark_support.dart';
import 'package:kaiteki/fediverse/interfaces/favorite_support.dart';
import 'package:kaiteki/fediverse/interfaces/reaction_support.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/theming/kaiteki/colors.dart';
import 'package:kaiteki/ui/debug/text_render_dialog.dart';
import 'package:kaiteki/ui/shared/posts/attachment_row.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';
import 'package:kaiteki/ui/shared/posts/card_widget.dart';
import 'package:kaiteki/ui/shared/posts/embedded_post.dart';
import 'package:kaiteki/ui/shared/posts/interaction_bar.dart';
import 'package:kaiteki/ui/shared/posts/interaction_event_bar.dart';
import 'package:kaiteki/ui/shared/posts/meta_bar.dart';
import 'package:kaiteki/ui/shared/posts/reaction_row.dart';
import 'package:kaiteki/ui/shared/posts/reply_bar.dart';
import 'package:kaiteki/ui/shared/posts/subject_bar.dart';
import 'package:kaiteki/ui/shared/posts/user_list_dialog.dart';
import 'package:kaiteki/ui/shared/text_inherited_icon_theme.dart';
import 'package:kaiteki/ui/shortcuts/activators.dart';
import 'package:kaiteki/ui/shortcuts/intents.dart';
import 'package:kaiteki/utils/extensions.dart';

const kPostPadding = EdgeInsets.symmetric(vertical: 4.0);

class PostWidget extends ConsumerStatefulWidget {
  final Post post;
  final bool showParentPost;
  final bool showActions;
  final bool wide;
  final bool hideReplyee;
  final bool hideAvatar;

  const PostWidget(
    this.post, {
    super.key,
    this.showParentPost = true,
    this.showActions = true,
    this.wide = false,
    this.hideReplyee = false,
    this.hideAvatar = false,
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
          InteractionEventBar(
            icon: Icons.repeat_rounded,
            text: l10n.postRepeated,
            color: Theme.of(context).ktkColors!.repeatColor,
            user: _post.author,
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
        ReplyIntent: CallbackAction(
          onInvoke: (_) {
            return context.showPostDialog(replyTo: _post);
          },
        ),
        FavoriteIntent: CallbackAction(onInvoke: (_) => _onFavorite()),
        RepeatIntent: CallbackAction(onInvoke: (_) => _onRepeat()),
        BookmarkIntent: CallbackAction(onInvoke: (_) => _onBookmark()),
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.wide && !widget.hideAvatar)
            Padding(
              padding: const EdgeInsets.all(8),
              child: AvatarWidget(
                _post.author,
                onTap: () => context.showUser(_post.author, ref),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MetaBar(
                    post: _post,
                    showAvatar: !widget.hideAvatar && widget.wide,
                  ),
                  if (widget.showParentPost && _post.replyToPostId != null)
                    ReplyBar(post: _post),
                  PostContentWidget(
                    post: _post,
                    hideReplyee: widget.hideReplyee,
                  ),
                  if (_post.quotedPost != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [EmbeddedPostWidget(_post.quotedPost!)],
                    ),
                  if (_post.attachments?.isNotEmpty == true)
                    AttachmentRow(post: _post),
                  if (_post.previewCard != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CardWidget(card: _post.previewCard!),
                    ),
                  if (_post.reactions.isNotEmpty)
                    ReactionRow(_post, _post.reactions),
                  if (widget.showActions)
                    InteractionBar(
                      post: _post,
                      onReply: () => context.showPostDialog(replyTo: _post),
                      onFavorite: _onFavorite,
                      onRepeat: _onRepeat,
                      favorited: adapter is FavoriteSupport //
                          ? _post.liked
                          : null,
                      onShowFavoritees: _showFavoritees,
                      onShowRepeatees: _showRepeatees,
                      repeated: _post.repeated,
                      reacted: adapter is ReactionSupport ? false : null,
                      buildActions: _buildActions,
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showFavoritees() async {
    await showDialog(
      context: context,
      builder: (_) => Consumer(
        builder: (_, ref, __) {
          final adapter = ref.watch(adapterProvider);
          return UserListDialog(
            title: const Text("Favorited by"),
            fetchUsers: () async {
              final users =
                  await (adapter as FavoriteSupport).getFavoritees(_post.id);
              return users;
            }(),
            emptyIcon: const Icon(Icons.star_outline_rounded),
            emptyTitle: const Text("No favorites"),
          );
        },
      ),
    );
  }

  Future<void> _showRepeatees() async {
    showDialog(
      context: context,
      builder: (_) => Consumer(
        builder: (_, ref, __) {
          final adapter = ref.watch(adapterProvider);
          return UserListDialog(
            title: const Text("Repeated by"),
            fetchUsers: () async {
              final users = await adapter.getRepeatees(
                _post.id,
              );
              return users;
            }(),
            emptyIcon: const Icon(Icons.repeat_rounded),
            emptyTitle: const Text("No repeats"),
          );
        },
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
              _post.bookmarked
                  ? l10n.postRemoveFromBookmarks
                  : l10n.postAddToBookmarks,
            ),
            leading: Icon(
              _post.bookmarked
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
        value: () => context.launchUrl(_post.externalUrl!),
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

  Future<void> _onFavorite() async {
    final adapter = ref.read(adapterProvider);
    final l10n = context.getL10n();
    try {
      final f = adapter as FavoriteSupport;
      final newPost = _post.liked
          ? await f.unfavoritePost(_post.id)
          : await f.favoritePost(_post.id);

      setState(() => _post = newPost!);
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
      final newPost = _post.bookmarked
          ? await f.unbookmarkPost(_post.id)
          : await f.bookmarkPost(_post.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const TextInheritedIconTheme(child: Icon(Icons.check_rounded)),
                const SizedBox(width: 8),
                Text(
                  _post.bookmarked
                      ? l10n.postBookmarkRemoved
                      : l10n.postBookmarkAdded,
                ),
              ],
            ),
          ),
        );
      }

      setState(() => _post = newPost!);
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
      final newPost = _post.repeated
          ? await adapter.unrepeatPost(_post.id)
          : (await adapter.repeatPost(_post.id))!.repeatOf!;

      setState(() => _post = newPost!);
    } catch (e, s) {
      context.showErrorSnackbar(
        text: Text(l10n.postRepeatFailed),
        stackTrace: s,
        error: e,
      );
    }
  }
}

class PostContentWidget extends ConsumerStatefulWidget {
  final Post post;
  final bool hideReplyee;

  const PostContentWidget({
    super.key,
    required this.post,
    required this.hideReplyee,
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
        if (renderedContent != null && !collapsed)
          Padding(
            padding: kPostPadding,
            child: SelectableText.rich(TextSpan(children: [renderedContent!])),
          ),
      ],
    );
  }
}
