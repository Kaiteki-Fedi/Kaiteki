import "package:kaiteki/fediverse/model/chat_message.dart";
import "package:kaiteki/fediverse/model/chat_target.dart";

abstract class ChatSupport {
  ChatSupportCapabilities get capabilities;

  Future<Iterable<ChatTarget>> getChats();

  Future<ChatMessage> postChatMessage(ChatTarget chat, ChatMessage message);

  Future<Iterable<ChatMessage>> getChatMessages(ChatTarget chat);
}

abstract class ChatSupportCapabilities {
  bool get supportsChat;

  const ChatSupportCapabilities();
}
