import 'package:kaiteki/fediverse/model/chat_message.dart';
import 'package:kaiteki/fediverse/model/chat_recipient.dart';

class Chat {
  String id;
  DateTime createdAt;
  ChatMessage lastMessage;
  ChatRecipient recipient;
}
