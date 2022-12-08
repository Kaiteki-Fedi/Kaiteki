import 'package:kaiteki/fediverse/model/post/post.dart';
import 'package:kaiteki/fediverse/model/user/user.dart';

class ChatMessage {
  final DateTime sentAt;
  final User user;
  final Post content;
  final Iterable<User> recipients;

  const ChatMessage({
    required this.user,
    required this.content,
    required this.recipients,
    required this.sentAt,
  });
}
