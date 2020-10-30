import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/model/fediverse/attachment.dart';
import 'package:kaiteki/model/fediverse/chat.dart';
import 'package:kaiteki/model/fediverse/chat_message.dart';
import 'package:kaiteki/utils/text_renderer.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:kaiteki/ui/widgets/attachments/image_attachment_widget.dart';
import 'package:kaiteki/ui/widgets/avatar_widget.dart';
import 'package:provider/provider.dart';

class ChatMessageWidget extends StatefulWidget {
  ChatMessageWidget(this.chat, this.chatMessage, {Key key}) : super(key: key);

  final Chat chat;

  final ChatMessage chatMessage;
  @override
  _ChatMessageWidgetState createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  // TODO: resolve temporary workaround
  get isOwnMessage => true;
  //get isOwnMessage => widget.chat.recipient.id != widget.chatMessage.accountId;
  get alignment =>
      isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start;

  static const double avatarSize = 32;

  @override
  Widget build(BuildContext context) {
    var container = Provider.of<ThemeContainer>(context);
    var appTheme = container.current;

    var msgTheme = isOwnMessage
        ? appTheme.outgoingChatMessage
        : appTheme.incomingChatMessage;

    return LayoutBuilder(
      builder: (_, b) => Row(
        mainAxisAlignment: alignment,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: conditionalReverse(isOwnMessage, [
          if (!isOwnMessage)
            Padding(
              padding: getAvatarPadding(isOwnMessage),
              child: AvatarWidget(widget.chatMessage.user, size: avatarSize),
            ),
          Container(
              constraints: BoxConstraints.tightFor(width: b.maxWidth * 0.8),
              padding: const EdgeInsets.all(10.5),
              decoration: BoxDecoration(
                  color: msgTheme.background,
                  borderRadius:
                      BorderRadius.circular(appTheme.chatMessageRounding),
                  border: Border.all(color: msgTheme.border, width: 1)),
              child: Column(
                children: [
                  RichText(
                      text: TextRenderer(
                    emojis: widget.chatMessage.content.emojis,
                    textStyle: TextStyle(color: appTheme.textColor),
                  ).render(widget.chatMessage.content.content)),
                  for (var attachment in widget.chatMessage.content.attachments)
                    getAttachmentWidget(attachment),
                ],
              )),
        ]),
      ),
    );
  }

  EdgeInsets getAvatarPadding(bool direction, {double value = 10}) {
    if (direction)
      return EdgeInsets.only(left: value);
    else
      return EdgeInsets.only(right: value);
  }

  List<T> conditionalReverse<T>(bool cond, List<T> list) {
    if (cond) return list.reversed.toList(growable: false);

    return list;
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
