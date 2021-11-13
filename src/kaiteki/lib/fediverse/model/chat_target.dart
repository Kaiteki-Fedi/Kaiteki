import 'package:kaiteki/fediverse/model/chat_message.dart';
import 'package:kaiteki/fediverse/model/user.dart';

abstract class ChatTarget<T> {
  final T source;
  final String id;
  final DateTime createdAt;
  final ChatMessage? lastMessage;
  final int unreadMessages;

  const ChatTarget({
    required this.id,
    required this.createdAt,
    required this.source,
    this.lastMessage,
    this.unreadMessages = 0,
  });
}

class GroupChat<T> extends ChatTarget<T> {
  final List<User> recipients;

  const GroupChat({
    required source,
    required id,
    required createdAt,
    required this.recipients,
    lastMessage,
    unreadMessages = 0,
  }) : super(
          source: source,
          id: id,
          createdAt: createdAt,
          lastMessage: lastMessage,
          unreadMessages: unreadMessages,
        );
}

class DirectChat<T> extends ChatTarget<T> {
  final User recipient;

  const DirectChat({
    required source,
    required id,
    required createdAt,
    required this.recipient,
    lastMessage,
    unreadMessages = 0,
  }) : super(
          source: source,
          id: id,
          createdAt: createdAt,
          lastMessage: lastMessage,
          unreadMessages: unreadMessages,
        );
}
