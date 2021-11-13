part of 'adapter.dart';

ChatMessage toChatMessage(
  pleroma.ChatMessage message,
  pleroma.Chat chat,
  User currentUser,
) {
  final attachment = message.attachment;

  return ChatMessage(
    content: message.content,
    author: message.accountId == chat.account.id
        ? toUser(chat.account)
        : currentUser,
    sentAt: message.createdAt,
    attachments: [
      if (attachment != null) toAttachment(attachment),
    ],
    emojis: message.emojis.map(toEmoji).toList(growable: false),
  );
}

ChatTarget toChatTarget(pleroma.Chat chat, User currentUser) {
  return DirectChat(
    source: chat,
    id: chat.id,
    lastMessage: chat.lastMessage.nullTransform((msg) {
      return toChatMessage(msg, chat, currentUser);
    }),
    recipient: toUser(chat.account),
    createdAt: DateTime.now(),
    unreadMessages: chat.unread,
  );
}
