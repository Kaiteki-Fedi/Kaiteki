import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/theming/kaiteki_extension.dart';
import 'package:kaiteki/ui/intents.dart';
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
import 'package:kaiteki/ui/shortcut_keys.dart';
import 'package:kaiteki/utils/extensions.dart';

const kPostPadding = EdgeInsets.symmetric(vertical: 4.0);

class PostWidget extends ConsumerStatefulWidget {
  final Post post;
  final bool showParentPost;
  final bool showActions;
  final bool wide;
  final bool hideReplyee;

  const PostWidget(
    this.post, {
    Key? key,
    this.showParentPost = true,
    this.showActions = true,
    this.wide = false,
    this.hideReplyee = false,
  }) : super(key: key);

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
            color: context.kaitekiExtension!.repeatColor,
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

    return FocusableActionDetector(
      shortcuts: {
        replyKeySet: ReplyIntent(),
        repeatKeySet: RepeatIntent(),
        favoriteKeySet: FavoriteIntent(),
        // ShortcutKeys.reactKeySet: ReactIntent(),
        menuKeySet: MenuIntent(),
      },
      actions: {
        ReplyIntent: CallbackAction(
          onInvoke: (_) {
            return context.showPostDialog(replyTo: _post);
          },
        ),
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.wide)
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
                    showAvatar: widget.wide,
                  ),
                  if (widget.showParentPost && _post.replyToPostId != null)
                    ReplyBar(post: _post),
                  PostContentWidget(
                      post: _post, hideReplyee: widget.hideReplyee),
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
                      onFavorite: () async {
                        final adapter = ref.read(adapterProvider);
                        try {
                          final newPost = _post.liked
                              ? await adapter.unfavoritePost(_post.id)
                              : await adapter.favoritePost(_post.id);

                          setState(() => _post = newPost!);
                        } catch (e, s) {
                          context.showErrorSnackbar(
                            text: const Text("Failed to favorite post"),
                            stackTrace: s,
                            error: e,
                          );
                        }
                      },
                      onRepeat: () async {
                        final adapter = ref.read(adapterProvider);
                        try {
                          final newPost = _post.repeated
                              ? await adapter.unrepeatPost(_post.id)
                              : (await adapter.repeatPost(_post.id))!.repeatOf!;

                          setState(() => _post = newPost!);
                        } catch (e, s) {
                          context.showErrorSnackbar(
                            text: const Text("Failed to repeat post"),
                            stackTrace: s,
                            error: e,
                          );
                        }
                      },
                      favorited: _post.liked,
                      repeated: _post.repeated,
                      reacted: false,
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PostContentWidget extends ConsumerStatefulWidget {
  final Post post;
  final bool hideReplyee;

  const PostContentWidget({
    Key? key,
    required this.post,
    required this.hideReplyee,
  }) : super(key: key);

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
            child: Text.rich(renderedContent!),
          ),
      ],
    );
  }
}
