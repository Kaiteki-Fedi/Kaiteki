import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/fediverse/model/user_reference.dart';
import 'package:kaiteki/fediverse/model/visibility.dart';
import 'package:kaiteki/theming/app_themes/app_theme.dart';
import 'package:kaiteki/ui/dialogs/debug/text_render_dialog.dart';
import 'package:kaiteki/ui/intents.dart';
import 'package:kaiteki/ui/shortcut_keys.dart';
import 'package:kaiteki/ui/widgets/attachments.dart';
import 'package:kaiteki/ui/widgets/posts/avatar_widget.dart';
import 'package:kaiteki/ui/widgets/posts/card_widget.dart';
import 'package:kaiteki/ui/widgets/posts/count_button.dart';
import 'package:kaiteki/ui/widgets/posts/interaction_event_bar.dart';
import 'package:kaiteki/ui/widgets/posts/reaction_row.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:kaiteki/utils/utils.dart';
import 'package:mdi/mdi.dart';

const _padding = EdgeInsets.symmetric(vertical: 4.0);

class StatusWidget extends ConsumerWidget {
  final Post _post;
  final bool showParentPost;
  final bool showActions;
  final bool wide;

  const StatusWidget(
    this._post, {
    Key? key,
    this.showParentPost = true,
    this.showActions = true,
    this.wide = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const authorTextStyle = TextStyle(fontWeight: FontWeight.bold);
    final theme = ref.watch(themeProvider).current;
    final l10n = context.getL10n();

    if (_post.repeatOf != null) {
      return Column(
        children: [
          InteractionEventBar(
            icon: Mdi.repeat,
            text: l10n.postRepeated,
            color: theme.repeatColor,
            user: _post.author,
            userTextStyle: authorTextStyle,
          ),
          StatusWidget(
            _post.repeatOf!,
            showActions: showActions,
            wide: wide,
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
          if (!wide)
            Padding(
              padding: const EdgeInsets.all(8),
              child: AvatarWidget(
                _post.author,
                onTap: () => context.showUser(_post.author),
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
                    renderedAuthor:
                        _post.author.renderDisplayName(context, ref),
                    authorTextStyle: authorTextStyle,
                    post: _post,
                    theme: theme,
                    showAvatar: wide,
                  ),
                  if (showParentPost && _post.replyToPostId != null)
                    ReplyBar(post: _post),
                  PostContentWidget(post: _post),
                  if (_post.attachments?.isNotEmpty == true)
                    AttachmentRow(post: _post),
                  if (_post.previewCard != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CardWidget(card: _post.previewCard!),
                    ),
                  if (_post.reactions.isNotEmpty)
                    ReactionRow(_post, _post.reactions),
                  if (showActions) InteractionBar(post: _post, theme: theme),
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

  const PostContentWidget({Key? key, required this.post}) : super(key: key);

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
      renderedContent = post.renderContent(context, ref);
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
            padding: _padding,
            child: Text.rich(renderedContent!),
          ),
      ],
    );
  }
}

class MetaBar extends StatelessWidget {
  const MetaBar({
    Key? key,
    required this.renderedAuthor,
    required Post post,
    required this.theme,
    this.authorTextStyle,
    this.showAvatar = false,
  })  : _post = post,
        super(key: key);

  final InlineSpan renderedAuthor;
  final Post _post;
  final AppTheme theme;
  final TextStyle? authorTextStyle;
  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    final secondaryText = _getSecondaryUserText(_post.author);
    final secondaryColor = Theme.of(context).disabledColor;
    final secondaryTextTheme = TextStyle(color: secondaryColor);
    var textSpacing = 0.0;

    if (showAvatar) {
      textSpacing = 0.0;
    } else if (!_equalUserName(_post.author)) {
      textSpacing = 6.0;
    }

    return Padding(
      padding: _padding.copyWith(top: 0),
      child: Row(
        children: [
          if (showAvatar)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: AvatarWidget(_post.author, size: 40),
            ),
          Expanded(
            child: Wrap(
              direction: showAvatar ? Axis.vertical : Axis.horizontal,
              spacing: textSpacing,
              children: [
                Text.rich(renderedAuthor, style: authorTextStyle),
                if (secondaryText != null)
                  Text(
                    secondaryText,
                    style: secondaryTextTheme,
                    overflow: TextOverflow.fade,
                  ),
              ],
            ),
          ),
          Tooltip(
            message: _post.postedAt.toString(),
            child: Text(
              DateTime.now().difference(_post.postedAt).toStringHuman(
                    context: context,
                  ),
              style: secondaryTextTheme,
            ),
          ),
          // if (_post.visibility != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Tooltip(
              message: _post.visibility.toHumanString(),
              child: Icon(
                _post.visibility.toIconData(),
                size: 20,
                color: secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _getSecondaryUserText(User user) {
    if (!showAvatar) {
      String? result;

      if (!_equalUserName(user)) {
        result = user.username;
      }

      final host = user.host;
      if (host != null) {
        result = (result ?? '') + '@$host';
      }

      return result;
    }

    return user.handle;
  }

  bool _equalUserName(User user) {
    return user.username.toLowerCase() == user.displayName.toLowerCase();
  }
}

class ReplyBar extends ConsumerWidget {
  const ReplyBar({
    Key? key,
    this.textStyle,
    required this.post,
  }) : super(key: key);

  final TextStyle? textStyle;
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeContainer = ref.watch(themeProvider);
    final disabledColor = Theme.of(context).disabledColor;
    final l10n = context.getL10n();
    final adapter = ref.watch(accountProvider).adapter;

    return Padding(
      padding: _padding,
      child: FutureBuilder<User?>(
        future: UserReference(_getUserId()).resolve(adapter),
        builder: (context, snapshot) {
          final span = snapshot.hasData
              ? snapshot.data!.renderDisplayName(context, ref)
              : TextSpan(
                  text: _getText(),
                  style: themeContainer.current.linkTextStyle,
                );

          return Text.rich(
            TextSpan(
              style: textStyle,
              children: [
                // TODO(Craftplacer): refactor the following widget pattern to a future "IconSpan"
                WidgetSpan(
                  child: Icon(
                    Mdi.share,
                    size: getLocalFontSize(context) * 1.25,
                    color: disabledColor,
                  ),
                ),
                TextSpan(
                  text: ' ' + l10n.replyTo + ' ',
                  style: TextStyle(color: disabledColor),
                ),
                span,
              ],
            ),
          );
        },
      ),
    );
  }

  String _getText() {
    final user = post.replyToUser;
    if (user != null) {
      return '@' + user.username;
    }

    final id = post.replyToUserId;
    if (id != null) {
      return id;
    }

    return "unknown user";
  }

  String _getUserId() {
    if (post.replyToUserId != null) return post.replyToUserId!;
    if (post.replyTo != null) return post.replyTo!.author.id;
    throw Exception("Can't find user id as reply");
  }
}

class InteractionBar extends StatelessWidget {
  const InteractionBar({
    Key? key,
    required Post post,
    required this.theme,
  })  : _post = post,
        super(key: key);

  final Post _post;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final openInBrowserAvailable = _post.externalUrl != null;
    final l10n = context.getL10n();

    // Added Material for fixing bork with Hero *shrug*
    return Row(
      children: [
        CountButton(
          icon: const Icon(Icons.reply),
          count: _post.replyCount,
          buttonOnly: true,
          onTap: () => context.showPostDialog(replyTo: _post),
          focusNode: FocusNode(skipTraversal: true),
        ),
        CountButton(
          icon: const Icon(Icons.repeat),
          count: _post.repeatCount,
          active: _post.repeated,
          activeColor: theme.repeatColor,
          focusNode: FocusNode(skipTraversal: true),
        ),
        CountButton(
          icon: const Icon(Mdi.starOutline),
          count: _post.likeCount,
          active: _post.liked,
          activeColor: theme.favoriteColor,
          activeIcon: const Icon(Icons.star),
          focusNode: FocusNode(skipTraversal: true),
        ),
        IconButton(
          icon: const Icon(Icons.insert_emoticon),
          onPressed: null,
          focusNode: FocusNode(skipTraversal: true),
        ),
        PopupMenuButton<VoidCallback>(
          icon: const Icon(Icons.more_horiz),
          onSelected: (callback) => callback.call(),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                enabled: openInBrowserAvailable,
                child: ListTile(
                  title: Text(l10n.openInBrowserLabel),
                  leading: const Icon(Mdi.openInNew),
                  contentPadding: EdgeInsets.zero,
                  enabled: openInBrowserAvailable,
                ),
                value: () => context.launchUrl(_post.externalUrl!),
              ),
              PopupMenuItem(
                child: const ListTile(
                  title: Text("Debug text rendering"),
                  leading: Icon(Mdi.bug),
                  contentPadding: EdgeInsets.zero,
                ),
                value: () => showDialog(
                  context: context,
                  builder: (context) => TextRenderDialog(_post),
                ),
              ),
            ];
          },
        ),
      ],
    );
  }
}

class AttachmentRow extends StatelessWidget {
  final Post post;

  const AttachmentRow({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final border = Theme.of(context).dividerColor;
    final borderRadius = BorderRadius.circular(8);
    var attachmentIndex = 0;

    return LimitedBox(
      maxHeight: 280,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var attachment in post.attachments!.take(4))
            Flexible(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  border: Border.all(color: border),
                ),
                child: getAttachmentWidget(
                  post,
                  attachment,
                  attachmentIndex++,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SubjectBar extends StatelessWidget {
  final String subject;
  final bool collapsed;
  final VoidCallback? onTap;

  const SubjectBar({
    Key? key,
    required this.subject,
    required this.collapsed,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Column(
        children: [
          ListTile(
            title: Text(
              subject,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            trailing: collapsed
                ? const Icon(Mdi.chevronUp)
                : const Icon(Mdi.chevronDown),
            contentPadding: EdgeInsets.zero,
            onTap: onTap,
          ),
          if (!collapsed)
            Column(
              children: const [
                Divider(height: 1),
                SizedBox(height: 8),
              ],
            ),
        ],
      ),
    );
  }
}
