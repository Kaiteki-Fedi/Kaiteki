import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/model/fediverse/attachment.dart';
import 'package:kaiteki/model/fediverse/post.dart';
import 'package:kaiteki/ui/widgets/card_widget.dart';
import 'package:kaiteki/ui/widgets/reaction_row.dart';
import 'package:kaiteki/utils/text_renderer.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:kaiteki/ui/widgets/attachments/image_attachment_widget.dart';
import 'package:kaiteki/ui/widgets/avatar_widget.dart';
import 'package:kaiteki/ui/widgets/interaction_bar.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class StatusWidget extends StatelessWidget {
  final Post _post;

  const StatusWidget(this._post);

  @override
  Widget build(BuildContext context) {

    var textStyle = TextStyle();

    var container = Provider.of<ThemeContainer>(context);
    var theme = container.current;

    if (_post.repeatOf != null) {
      return Column(
        children: [
          InteractionBar(
            icon: Mdi.repeat,
            text: "repeated",
            color: theme.repeatColor,
            user: _post.author,
          ),
          StatusWidget(_post.repeatOf),
        ],
      );
    }

    var renderedAuthor = TextRenderer(
      emojis: _post.author.emojis,
      textStyle: textStyle.copyWith(fontWeight: FontWeight.bold),
    ).render(_post.author.displayName);

    var renderedContent = TextRenderer(
      emojis: _post.emojis,
      textStyle: textStyle,
    ).render(_post.content);

    return Container(
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
                  Row(
                    children: [
                      if (renderedAuthor != null)
                        RichText(text: renderedAuthor),
                      Text(_post.author.username),
                      // TODO: fix
                      //Spacer(),
                      //Text(_post.visibility),
                    ],
                  ),
                  if (renderedContent != null)
                    RichText(text: renderedContent),
                  if (_post.attachments != null)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (var attachment in _post.attachments)
                          Flexible(
                            child: Container(
                              child: getAttachmentWidget(attachment),
                              height: 280,
                            ),
                          )
                      ],
                    ),

                  if (_post.previewCard != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CardWidget(card: _post.previewCard),
                    ),

                  if (_post.reactions != null)
                    ReactionRow(_post, _post.reactions),

                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.reply),
                        onPressed: null,
                      ),
                      IconButton(
                        icon: Icon(Icons.repeat),
                        onPressed: _post.repeated ? () {} : null,
                        color: _post.repeated ? theme.repeatColor : null,
                      ),
                      IconButton(
                        icon: Icon(_post.liked ? Mdi.star : Mdi.starOutline),
                        onPressed: _post.liked ? () {} : null,
                        color: _post.liked ? theme.favoriteColor : null,
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
                  ),
                  // ApplicationWidget(_post.application),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getAttachmentWidget(Attachment attachment) {
    switch (attachment.type) {
      case "image": return ImageAttachmentWidget(attachment);
      //case "video": return VideoAttachmentWidget(attachment);
      default: {
        print("Tried to present an unsupported attachment type: ${attachment.type}");
        return Container();
      }
    }
  }
}
