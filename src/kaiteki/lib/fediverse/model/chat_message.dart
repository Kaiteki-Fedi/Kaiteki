import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';

class ChatMessage {
  final DateTime sentAt;
  final User user;
  final Post content;
  final Iterable<User> recipients;

  const ChatMessage({
    this.user,
    this.content,
    this.recipients,
    this.sentAt,
  });
}
