import 'package:kaiteki/fediverse/model/chat_message.dart';
import 'package:kaiteki/fediverse/model/chat_recipient.dart';

class Chat {
  final String id;
  final DateTime createdAt;
  final ChatMessage lastMessage;
  final ChatRecipient recipient;

  Chat(this.id, this.createdAt, this.lastMessage, this.recipient);
}
