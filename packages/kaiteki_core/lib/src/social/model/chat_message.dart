import 'attachment.dart';
import 'emoji.dart';
import 'user.dart';

class ChatMessage {
  final DateTime sentAt;
  final User author;
  final String? content;
  final List<Attachment> attachments;
  final List<Emoji> emojis;

  const ChatMessage({
    required this.author,
    required this.content,
    required this.sentAt,
    required this.attachments,
    required this.emojis,
  });
}
