import 'package:fediverse_objects/pleroma/chat.dart';
import 'package:fediverse_objects/pleroma/chat_message.dart';
import 'package:kaiteki/api/api_type.dart';
import 'package:kaiteki/api/clients/mastodon_client.dart';
import 'package:kaiteki/api/responses/pleroma/emoji_packs_response.dart';
import 'package:kaiteki/model/http_method.dart';

class PleromaClient extends MastodonClient {
  @override
  ApiType get type => ApiType.Pleroma;

  Future<Iterable<PleromaChat>> getChats() async {
    return await sendJsonRequestMultiple(
      HttpMethod.GET,
      "api/v1/pleroma/chats",
      (json) => PleromaChat.fromJson(json),
    );
  }

  Future<Iterable<PleromaChatMessage>> getChatMessages(String id) async {
    return await sendJsonRequestMultiple(
      HttpMethod.GET,
      "api/v1/pleroma/chats/$id/messages",
      (j) => PleromaChatMessage.fromJson(j),
    );
  }

  Future<PleromaChatMessage> postChatMessage(String id, String message) async {
    return await sendJsonRequest(
      HttpMethod.POST,
      "api/v1/pleroma/chats/$id/messages",
      (j) => PleromaChatMessage.fromJson(j),
      body: {"content": message},
    );
  }

  Future<void> react(String postId, String emoji) async {
    return await sendJsonRequest(
      HttpMethod.PUT,
      "/api/v1/pleroma/statuses/$postId/reactions/$emoji",
      null,
    );
  }

  Future<void> removeReaction(String postId, String emoji) async {
    return await sendJsonRequest(
      HttpMethod.DELETE,
      "/api/v1/pleroma/statuses/$postId/reactions/$emoji",
      null,
    );
  }

  Future<PleromaEmojiPacksResponse> getEmojiPacks() async {
    return await sendJsonRequest(
      HttpMethod.GET,
      "/api/pleroma/emoji/packs",
      (json) => PleromaEmojiPacksResponse.fromJson(json),
    );
  }
}
