import 'package:fediverse_objects/pleroma.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/backends/mastodon/client.dart';
import 'package:kaiteki/fediverse/backends/pleroma/responses/emoji_packs_response.dart';
import 'package:kaiteki/model/http_method.dart';

class PleromaClient extends MastodonClient {
  @override
  ApiType get type => ApiType.pleroma;

  Future<Iterable<Chat>> getChats() async {
    return sendJsonRequestMultiple(
      HttpMethod.get,
      "api/v1/pleroma/chats",
      Chat.fromJson,
    );
  }

  Future<Iterable<ChatMessage>> getChatMessages(String id) async {
    return sendJsonRequestMultiple(
      HttpMethod.get,
      "api/v1/pleroma/chats/$id/messages",
      ChatMessage.fromJson,
    );
  }

  Future<ChatMessage> postChatMessage(String id, String message) async {
    return sendJsonRequest(
      HttpMethod.post,
      "api/v1/pleroma/chats/$id/messages",
      ChatMessage.fromJson,
      body: {"content": message},
    );
  }

  Future<void> react(String postId, String emoji) async {
    await sendJsonRequestWithoutResponse(
      HttpMethod.put,
      "/api/v1/pleroma/statuses/$postId/reactions/$emoji",
    );
  }

  Future<void> removeReaction(String postId, String emoji) async {
    await sendJsonRequestWithoutResponse(
      HttpMethod.delete,
      "/api/v1/pleroma/statuses/$postId/reactions/$emoji",
    );
  }

  Future<PleromaEmojiPacksResponse> getEmojiPacks() async {
    return sendJsonRequest(
      HttpMethod.get,
      "/api/pleroma/emoji/packs",
      PleromaEmojiPacksResponse.fromJson,
    );
  }

  Future<FrontendConfiguration> getFrontendConfigurations() async {
    return sendJsonRequest(
      HttpMethod.get,
      "/api/pleroma/frontend_configurations",
      FrontendConfiguration.fromJson,
    );
  }
}
