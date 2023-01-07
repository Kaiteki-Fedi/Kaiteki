import 'dart:convert';

import 'package:fediverse_objects/mastodon.dart' show Account, Notification;
import 'package:fediverse_objects/pleroma.dart';
import 'package:http/http.dart' show Response;
import 'package:kaiteki/fediverse/backends/mastodon/client.dart';
import 'package:kaiteki/fediverse/backends/pleroma/exceptions/mfa_required.dart';
import 'package:kaiteki/fediverse/backends/pleroma/responses/emoji_packs_response.dart';
import 'package:kaiteki/http/http.dart';

class PleromaClient extends MastodonClient {
  PleromaClient(super.instance);

  Future<List<Chat>> getChats() async => client
      .sendRequest(HttpMethod.get, "api/v1/pleroma/chats")
      .then(Chat.fromJson.fromResponseList);

  Future<Iterable<ChatMessage>> getChatMessages(String id) async => client
      .sendRequest(HttpMethod.get, "api/v1/pleroma/chats/$id/messages")
      .then(ChatMessage.fromJson.fromResponseList);

  Future<ChatMessage> postChatMessage(String id, String message) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/v1/pleroma/chats/$id/messages",
          body: {"content": message}.jsonBody,
        )
        .then(ChatMessage.fromJson.fromResponse);
  }

  Future<void> react(String postId, String emoji) async {
    await client.sendRequest(
      HttpMethod.put,
      "/api/v1/pleroma/statuses/$postId/reactions/$emoji",
    );
  }

  Future<void> removeReaction(String postId, String emoji) async {
    await client.sendRequest(
      HttpMethod.delete,
      "/api/v1/pleroma/statuses/$postId/reactions/$emoji",
    );
  }

  Future<PleromaEmojiPacksResponse> getEmojiPacks() async => client
      .sendRequest(HttpMethod.get, "/api/pleroma/emoji/packs")
      .then(PleromaEmojiPacksResponse.fromJson.fromResponse);

  Future<FrontendConfiguration> getFrontendConfigurations() async => client
      .sendRequest(HttpMethod.get, "/api/pleroma/frontend_configurations")
      .then(FrontendConfiguration.fromJson.fromResponse);

  @override
  void checkResponse(Response response) {
    if (response.statusCode == 403) {
      final json = jsonDecode(response.body);
      if (json["error"] == "mfa_required") {
        throw MfaRequiredException(json["mfa_token"]);
      }
    }

    super.checkResponse(response);
  }

  Future<Notification> markNotificationAsRead(int id) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "/api/v1/pleroma/notifications/read",
          body: {"id": id}.jsonBody,
        )
        .then(Notification.fromJson.fromResponse);
  }

  Future<List<Notification>> markNotificationsAsRead(int maxId) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "/api/v1/pleroma/notifications/read",
          body: {"max_id": maxId}.jsonBody,
        )
        .then(Notification.fromJson.fromResponseList);
  }

  Future<List<Account>> getAccountFollowersPleroma(
    String id, {
    String? maxId,
  }) async {
    return client.sendRequest(
      HttpMethod.get,
      "api/v1/accounts/$id/followers",
      query: {if (maxId != null) "max_id": maxId},
    ).then(Account.fromJson.fromResponseList);
  }

  Future<List<Account>> getAccountFollowingPleroma(
    String id, {
    String? maxId,
  }) async {
    return client.sendRequest(
      HttpMethod.get,
      "api/v1/accounts/$id/following",
      query: {if (maxId != null) "max_id": maxId},
    ).then(Account.fromJson.fromResponseList);
  }
}
