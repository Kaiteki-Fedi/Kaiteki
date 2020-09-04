import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/utils/text_renderer.dart';
import 'package:kaiteki/api/model/mastodon/account.dart';
import 'package:kaiteki/api/model/mastodon/media_attachment.dart';
import 'package:kaiteki/api/model/pleroma/chat.dart';
import 'package:kaiteki/api/model/pleroma/chat_message.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:kaiteki/ui/widgets/attachments/image_attachment_widget.dart';
import 'package:kaiteki/ui/widgets/avatar_widget.dart';
import 'package:provider/provider.dart';

class ChatMessageWidget extends StatefulWidget {
  ChatMessageWidget(this.chat, this.chatMessage, {Key key}) : super(key: key);

  final PleromaChat chat;
  final PleromaChatMessage chatMessage;

  @override
  _ChatMessageWidgetState createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  get isOwnMessage => widget.chat.account.id != widget.chatMessage.accountId;
  get alignment => isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start;

  static const double avatarSize = 32;

  @override
  Widget build(BuildContext context) {
    var container = Provider.of<ThemeContainer>(context);
    var appTheme = container.currentTheme;

    var background = isOwnMessage
        ? appTheme.outgoingChatMessageBackgroundColor
        : appTheme.incomingChatMessageBackgroundColor;

    var border = isOwnMessage
        ? appTheme.outgoingChatMessageBorderColor
        : appTheme.incomingChatMessageBorderColor;

    return LayoutBuilder(
      builder: (_, b) => Row(
        mainAxisAlignment: alignment,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: conditionalReverse(isOwnMessage, [
          if (!isOwnMessage)
          Padding(

            padding: getAvatarPadding(isOwnMessage),
            child: AvatarWidget(isOwnMessage ? MastodonAccount.example() : widget.chat.account, size: avatarSize),
          ),
          Container(
            constraints: BoxConstraints.tightFor(width: b.maxWidth * 0.8),
            padding: const EdgeInsets.all(10.5),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(appTheme.chatMessageRounding),
              border: Border.all(
                color: border,
                width: 1
              )
            ),
            child: widget.chatMessage.attachment == null
              ? RichText(
                text: TextRenderer(
                  emojis: widget.chatMessage.emojis,
                  textStyle: TextStyle(color: appTheme.textColor),
                ).render(widget.chatMessage.content)
              )
              : getAttachmentWidget(widget.chatMessage.attachment),
          ),
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
    if (cond)
      return list.reversed.toList(growable: false);

    return list;
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