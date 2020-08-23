import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/TextRenderer.dart';
import 'package:kaiteki/api/model/mastodon/media_attachment.dart';
import 'package:kaiteki/api/model/mastodon/status.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:kaiteki/ui/widgets/attachments/image_attachment_widget.dart';
import 'package:kaiteki/ui/widgets/avatar_widget.dart';
import 'package:kaiteki/ui/widgets/interaction_bar.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class StatusWidget extends StatelessWidget {
  final MastodonStatus _status;

  const StatusWidget(this._status);

  @override
  Widget build(BuildContext context) {
    var green = Colors.greenAccent.shade200;
    var orange = Colors.orangeAccent.shade200;
    var textStyle = TextStyle();

    var container = Provider.of<ThemeContainer>(context);

    var pleromaTheme = container.getCurrentPleromaTheme();
    if (pleromaTheme != null) {
      green = pleromaTheme.colors["cGreen"];
      orange = pleromaTheme.colors["cOrange"];
      textStyle = TextStyle(
        color: pleromaTheme.colors["text"]
      );
    }

    if (_status.reblog != null) {
      return Column(
        children: [
          InteractionBar(
            icon: Mdi.repeat,
            text: "repeated",
            color: green,
            account: _status.account,
          ),
          StatusWidget(_status.reblog),
        ],
      );
    }

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: AvatarWidget(_status.account, size: 48),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextRenderer(
                      emojis: _status.account.emojis,
                      textStyle: textStyle.copyWith(fontWeight: FontWeight.bold),
                    ).render(_status.account.displayName)
                  ),
                  RichText(
                    text: TextRenderer(
                      emojis: _status.emojis,
                      textStyle: textStyle,
                    ).render(_status.content)
                  ),
                  if (_status.mediaAttachments != null)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (var attachment in _status.mediaAttachments)
                          Flexible(
                            child: Container(
                              child: getAttachmentWidget(attachment),
                              height: 280,
                            ),
                          )
                      ],
                    ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.reply),
                        onPressed: (){},
                      ),
                      IconButton(
                        icon: Icon(Icons.repeat),
                        onPressed: (){},
                        color: _status.reblogged ? green : null
                      ),
                      IconButton(
                        icon: Icon(_status.favourited ? Mdi.star : Mdi.starOutline),
                        onPressed: (){},
                        color: _status.favourited ? orange : null
                      ),
                      IconButton(
                        icon: Icon(Icons.insert_emoticon),
                        onPressed: (){},
                      ),
                      IconButton(
                        icon: Icon(Icons.more_horiz),
                        onPressed: (){},
                      ),
                    ],
                  ),
                  // ApplicationWidget(_status.application),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getAttachmentWidget(MastodonMediaAttachment attachment) {
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
