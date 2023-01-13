import "package:kaiteki/fediverse/model/model.dart";

abstract class ChatTarget<T> {
  final T source;
  final String id;
  final DateTime? createdAt;
  final ChatMessage? lastMessage;
  final bool unread;

  const ChatTarget({
    required this.id,
    required this.createdAt,
    required this.source,
    this.lastMessage,
    this.unread = false,
  });
}

class GroupChat<T> extends ChatTarget<T> {
  final String? name;
  final List<User> recipients;

  const GroupChat({
    required super.source,
    required super.id,
    super.createdAt,
    required this.recipients,
    super.lastMessage,
    super.unread = false,
    this.name,
  });

  String get fallbackName {
    return recipients.map((e) => e.username).join(", ");
  }
}

class DirectChat<T> extends ChatTarget<T> {
  final User recipient;

  const DirectChat({
    required super.source,
    required super.id,
    super.createdAt,
    required this.recipient,
    super.lastMessage,
    super.unread = false,
  });
}
