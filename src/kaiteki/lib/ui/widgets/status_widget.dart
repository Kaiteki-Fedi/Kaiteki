import 'package:flutter/material.dart';
import 'package:kaiteki/model/fediverse/attachment.dart';
import 'package:kaiteki/model/fediverse/post.dart';
import 'package:kaiteki/model/fediverse/visibility.dart';
import 'package:kaiteki/theming/app_theme.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:kaiteki/ui/widgets/attachments/image_attachment_widget.dart';
import 'package:kaiteki/ui/widgets/posts/avatar_widget.dart';
import 'package:kaiteki/ui/widgets/posts/card_widget.dart';
import 'package:kaiteki/ui/widgets/posts/count_button.dart';
import 'package:kaiteki/ui/widgets/posts/interaction_event_bar.dart';
import 'package:kaiteki/ui/widgets/posts/reaction_row.dart';
import 'package:kaiteki/utils/extensions/duration.dart';
import 'package:kaiteki/utils/text/text_renderer.dart';
import 'package:kaiteki/utils/text/text_renderer_theme.dart';
import 'package:kaiteki/utils/utils.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class StatusWidget extends StatelessWidget {
  final Post _post;
  final VoidCallback onTap;
  final bool showParentPost;

  const StatusWidget(this._post, {this.onTap, this.showParentPost = true});

  @override
  Widget build(BuildContext context) {
    var container = Provider.of<ThemeContainer>(context);
    var theme = container.current;

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
          // Passing over onTap in this case sort of reveals a bad design
          // *maybe* require letting the parent handle taps?
          StatusWidget(_post.repeatOf, onTap: onTap),
        ],
      );
    }

    var renderedAuthor = TextRenderer(
      emojis: _post.author.emojis,
      theme: TextRendererTheme.fromContext(context),
    ).renderFromHtml(_post.author.displayName);

    var renderedContent = TextRenderer(
      emojis: _post.emojis,
      theme: TextRendererTheme.fromContext(context),
    ).renderFromHtml(_post.content);

    return InkWell(
      onTap: onTap,
      child: Container(
        child: Row(
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

                    if (renderedContent != null)
                      RichText(text: renderedContent),

                    if (_post.attachments != null)
                      AttachmentRow(
                        attachments: _post.attachments.toList(growable: false),
                      ),

                    if (_post.previewCard != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: CardWidget(card: _post.previewCard),
                      ),

                    if (_post.reactions != null)
                      ReactionRow(_post, _post.reactions),

                    InteractionBar(post: _post, theme: theme),
                    // ApplicationWidget(_post.application),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MetaBar extends StatelessWidget {
  const MetaBar({
    Key key,
    @required this.renderedAuthor,
    @required Post post,
    @required this.theme,
  })  : _post = post,
        super(key: key);

  final InlineSpan renderedAuthor;
  final Post _post;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (renderedAuthor != null) RichText(text: renderedAuthor),
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Text(
            _post.author.username,
            style: TextStyle(
              color: theme.materialTheme.disabledColor,
            ),
          ),
        ),
        Spacer(),
        Text(
          DateTime.now().difference(_post.postedAt).toStringHuman(),
          style: TextStyle(
            color: theme.materialTheme.disabledColor,
          ),
        ),
        if (_post.visibility != null)
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
    Key key,
    @required this.textStyle,
    @required Post post,
  })  : _post = post,
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
    Key key,
    @required Post post,
    @required this.theme,
  })  : _post = post,
        super(key: key);

  final Post _post;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CountButton(
          icon: Icon(Icons.reply),
          count: _post.replyCount,
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
        IconButton(
          icon: Icon(Icons.more_horiz),
          onPressed: null,
        ),
      ],
    );
  }
}

class AttachmentRow extends StatelessWidget {
  final List<Attachment> attachments;

  const AttachmentRow({
    Key key,
    @required this.attachments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (var attachment in attachments)
          Flexible(
            child: Container(
              child: getAttachmentWidget(attachment),
              height: 280,
            ),
          )
      ],
    );
  }

  Widget getAttachmentWidget(Attachment attachment) {
    switch (attachment.type) {
      case "image":
        return ImageAttachmentWidget(attachment);
      //case "video": return VideoAttachmentWidget(attachment);
      default:
        {
          print(
              "Tried to present an unsupported attachment type: ${attachment.type}");
          return Container();
        }
    }
  }
}
