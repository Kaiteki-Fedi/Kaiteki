import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/attachment.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/visibility.dart';
import 'package:kaiteki/theming/app_themes/app_theme.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:kaiteki/ui/forms/post_form.dart';
import 'package:kaiteki/ui/widgets/attachments/fallback_attachment_widget.dart';
import 'package:kaiteki/ui/widgets/attachments/image_attachment_widget.dart';
import 'package:kaiteki/ui/widgets/attachments/video_attachment_widget.dart';
import 'package:kaiteki/ui/widgets/posts/avatar_widget.dart';
import 'package:kaiteki/ui/widgets/posts/card_widget.dart';
import 'package:kaiteki/ui/widgets/posts/count_button.dart';
import 'package:kaiteki/ui/widgets/posts/interaction_event_bar.dart';
import 'package:kaiteki/ui/widgets/posts/reaction_row.dart';
import 'package:kaiteki/utils/extensions/duration.dart';
import 'package:kaiteki/utils/extensions/string.dart';
import 'package:kaiteki/utils/text/text_renderer.dart';
import 'package:kaiteki/utils/text/text_renderer_theme.dart';
import 'package:kaiteki/utils/utils.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class StatusWidget extends StatelessWidget {
  final Post _post;
  final bool showParentPost;
  final bool showActions;

  const StatusWidget(this._post, {this.showParentPost = true, this.showActions = true});

  @override
  Widget build(BuildContext context) {
    var container = Provider.of<ThemeContainer>(context);
    var theme = container.current;

    var postTextTheme = TextRendererTheme.fromContext(context);
    var authorTextTheme = TextRendererTheme.fromContext(
      context,
      fontWeight: FontWeight.bold,
    );

    var textStyle = DefaultTextStyle.of(context).style;
    var authorTextStyle = textStyle.copyWith(fontWeight: FontWeight.bold);

    if (_post.repeatOf != null) {
      return Column(
        children: [
          InteractionEventBar(
            icon: Mdi.repeat,
            text: "repeated",
            color: theme.repeatColor,
            user: _post.author,
            userTextStyle: authorTextStyle,
            textStyle: textStyle,
          ),
          StatusWidget(_post.repeatOf!),
        ],
      );
    }

    InlineSpan renderedAuthor = TextRenderer(
      emojis: _post.author.emojis,
      theme: authorTextTheme,
    ).renderFromHtml(_post.author.displayName);
    InlineSpan? renderedContent;

    if (_post.content.isNotNullOrEmpty) {
      renderedContent = TextRenderer(
        emojis: _post.emojis,
        theme: postTextTheme,
      ).renderFromHtml(_post.content!);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: AvatarWidget(_post.author, size: 48),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MetaBar(
                  renderedAuthor: renderedAuthor,
                  post: _post,
                  theme: theme,
                ),

                if (showParentPost && _post.replyToPostId != null)
                  ReplyBar(textStyle: textStyle, post: _post),

                if (renderedContent != null) RichText(text: renderedContent),

                if (_post.attachments != null)
                  AttachmentRow(
                    attachments: _post.attachments!.toList(growable: false),
                  ),

                if (_post.previewCard != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CardWidget(card: _post.previewCard!),
                  ),

                if (_post.reactions != null && _post.reactions.isNotEmpty)
                  ReactionRow(_post, _post.reactions),

                if (showActions)
                  InteractionBar(post: _post, theme: theme),
                // ApplicationWidget(_post.application),
              ],
            ),
          ),
        )
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
  })   : _post = post,
        super(key: key);

  final InlineSpan renderedAuthor;
  final Post _post;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              // if (renderedAuthor != null)
              RichText(text: renderedAuthor),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  _post.author.username,
                  style: TextStyle(
                    color: theme.materialTheme.disabledColor,
                  ),
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ),
        Text(
          DateTime.now().difference(_post.postedAt).toStringHuman(),
          style: TextStyle(
            color: theme.materialTheme.disabledColor,
          ),
        ),
        // if (_post.visibility != null)
        Icon(
          _post.visibility.toIconData(),
          size: 20,
          color: theme.materialTheme.disabledColor,
        ),
      ],
    );
  }
}

class ReplyBar extends StatelessWidget {
  const ReplyBar({
    Key? key,
    required this.textStyle,
    required Post post,
  })   : _post = post,
        super(key: key);

  final TextStyle textStyle;
  final Post _post;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: textStyle,
        children: [
          // TODO: refactor the following widget pattern to a future "IconSpan"
          WidgetSpan(
            child: Icon(
              Icons.reply,
              size: Utils.getLocalFontSize(context) * 1.25,
              color: Theme.of(context).disabledColor,
            ),
          ),
          TextSpan(
            text: " Reply to ",
            style: TextStyle(color: Theme.of(context).disabledColor),
          ),
          TextSpan(
            text: _post.replyToAccountId,
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ],
      ),
    );
  }
}

class InteractionBar extends StatelessWidget {
  const InteractionBar({
    Key? key,
    required Post post,
    required this.theme,
  })   : _post = post,
        super(key: key);

  final Post _post;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    var openInBrowserAvailable = _post.externalUrl != null;

    // Added Material for fixing bork with Hero *shrug*
    return Row(
      children: [
        CountButton(
          icon: Icon(Icons.reply),
          count: _post.replyCount,
          buttonOnly: true,
          onTap: () async {
            await showDialog(
              context: context,
              builder: (_) => Dialog(
                child: SizedBox(
                  child: Scaffold(body: PostForm(replyTo: _post)),
                  width: 800,
                  height: 500,
                ),
              ),
              barrierDismissible: true,
            );
          },
        ),
        CountButton(
          icon: Icon(Icons.repeat),
          count: _post.repeatCount,
          active: _post.repeated,
          activeColor: theme.repeatColor,
        ),
        CountButton(
          icon: Icon(Mdi.starOutline),
          count: _post.likeCount,
          active: _post.liked,
          activeColor: theme.favoriteColor,
          activeIcon: Icon(Icons.star),
        ),
        IconButton(
          icon: Icon(Icons.insert_emoticon),
          onPressed: null,
        ),
        PopupMenuButton<VoidCallback>(
          icon: Icon(Icons.more_horiz),
          onSelected: (callback) => callback.call(),
          itemBuilder: (BuildContext context) {
            return [
              new PopupMenuItem(
                enabled: openInBrowserAvailable,
                child: ListTile(
                  title: const Text('Open in browser'),
                  leading: const Icon(Mdi.openInNew),
                  contentPadding: const EdgeInsets.all(0.0),
                  enabled: openInBrowserAvailable,
                ),
                value: () async {
                  await launch(_post.externalUrl!);
                },
              ),
            ];
          },
        ),
      ],
    );
  }
}

class AttachmentRow extends StatelessWidget {
  final List<Attachment> attachments;

  const AttachmentRow({
    Key? key,
    required this.attachments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var border = Theme.of(context).dividerColor;
    var borderRadius = BorderRadius.circular(8);

    return LimitedBox(
      maxHeight: 280,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var attachment in attachments)
            Flexible(
              fit: FlexFit.loose,
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  // TODO (theming): Implement pleroma attachment rounding
                  borderRadius: borderRadius,
                  border: Border.all(color: border, width: 1),
                ),
                child: getAttachmentWidget(attachment),
              ),
            ),
        ],
      ),
    );
  }

  Widget getAttachmentWidget(Attachment attachment) {
    var supportsVideoPlayer = kIsWeb || Platform.isIOS || Platform.isAndroid;

    if (attachment.type == AttachmentType.image) {
      return ImageAttachmentWidget(attachment);
    } else if (attachment.type == AttachmentType.video && supportsVideoPlayer) {
      return VideoAttachmentWidget(attachment: attachment);
    } else {
      return FallbackAttachmentWidget(attachment: attachment);
    }
  }
}
