import 'package:kaiteki/model/fediverse/chat_message.dart';
import 'package:kaiteki/model/fediverse/chat_recipient.dart';

class Chat {
  String id;
  DateTime createdAt;
  ChatMessage lastMessage;
  ChatRecipient recipient;
}