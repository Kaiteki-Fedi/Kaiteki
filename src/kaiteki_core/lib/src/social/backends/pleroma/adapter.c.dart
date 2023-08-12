import 'package:fediverse_objects/pleroma.dart' as pleroma;
import 'package:kaiteki_core/src/social/backends/mastodon/extensions.dart';
import 'package:kaiteki_core/utils.dart';
import 'package:kaiteki_core/social.dart';

extension KaitekiPleromaChatMessageExtension on pleroma.ChatMessage {
  ChatMessage toKaiteki(pleroma.Chat chat, User currentUser) {
    final attachment = this.attachment;

    return ChatMessage(
      content: content,
      author: accountId == chat.account.id
          ? chat.account.toKaiteki(currentUser.host)
          : currentUser,
      sentAt: createdAt,
      attachments: [
        if (attachment != null) attachment.toKaiteki(),
      ],
      emojis: emojis
          .map((e) => e.toKaiteki(currentUser.host))
          .toList(growable: false),
    );
  }
}

extension KaitekiPleromaChatExtension on pleroma.Chat {
  DirectChat toKaiteki(User currentUser, String localHost) {
    return DirectChat(
      source: this,
      id: id,
      lastMessage: lastMessage.nullTransform((msg) {
        return msg.toKaiteki(this, currentUser);
      }),
      recipient: account.toKaiteki(localHost),
      createdAt: DateTime.now(),
      unread: unread != 0,
    );
  }
}
