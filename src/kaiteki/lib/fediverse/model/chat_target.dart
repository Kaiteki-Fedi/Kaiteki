import 'package:kaiteki/fediverse/model/model.dart';

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
    required super.source,
    required super.id,
    required super.createdAt,
    required this.recipients,
    super.lastMessage,
    super.unreadMessages = 0,
  });
}

class DirectChat<T> extends ChatTarget<T> {
  final User recipient;

  const DirectChat({
    required super.source,
    required super.id,
    required super.createdAt,
    required this.recipient,
    super.lastMessage,
    super.unreadMessages = 0,
  });
}
