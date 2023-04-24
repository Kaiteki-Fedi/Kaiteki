part of "adapter.dart";

ChatMessage toChatMessage(
  pleroma.ChatMessage message,
  pleroma.Chat chat,
  User currentUser,
) {
  final attachment = message.attachment;

  return ChatMessage(
    content: message.content,
    author: message.accountId == chat.account.id
        ? toUser(chat.account, currentUser.host)
        : currentUser,
    sentAt: message.createdAt,
    attachments: [
      if (attachment != null) toAttachment(attachment),
    ],
    emojis: message.emojis
        .map((e) => toEmoji(e, currentUser.host))
        .toList(growable: false),
  );
}

ChatTarget toChatTarget(pleroma.Chat chat, User currentUser, String localHost) {
  return DirectChat(
    source: chat,
    id: chat.id,
    lastMessage: chat.lastMessage.nullTransform((msg) {
      return toChatMessage(msg, chat, currentUser);
    }),
    recipient: toUser(chat.account, localHost),
    createdAt: DateTime.now(),
    unread: chat.unread != 0,
  );
}
