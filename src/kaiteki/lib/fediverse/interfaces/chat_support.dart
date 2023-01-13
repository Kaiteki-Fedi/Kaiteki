import "package:kaiteki/fediverse/model/chat_message.dart";
import "package:kaiteki/fediverse/model/chat_target.dart";

abstract class ChatSupport {
  Future<Iterable<ChatTarget>> getChats();

  Future<ChatMessage> postChatMessage(ChatTarget chat, ChatMessage message);

  Future<Iterable<ChatMessage>> getChatMessages(ChatTarget chat);
}
