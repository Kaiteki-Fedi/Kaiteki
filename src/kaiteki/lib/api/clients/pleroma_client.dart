import 'package:kaiteki/api/api_type.dart';
import 'package:kaiteki/api/clients/mastodon_client.dart';
import 'package:kaiteki/api/model/pleroma/chat.dart';
import 'package:kaiteki/api/model/pleroma/chat_message.dart';
import 'package:kaiteki/model/http_method.dart';

class PleromaClient extends MastodonClient {
  @override
  ApiType get type => ApiType.Pleroma;

  Future<Iterable<PleromaChat>> getChats() async =>
    await sendJsonRequestMultiple(
      HttpMethod.GET,
      "api/v1/pleroma/chats",
      (json) => PleromaChat.fromJson(json)
    );

  Future<Iterable<PleromaChatMessage>> getChatMessages(String id) async {
    return await sendJsonRequestMultiple(
      HttpMethod.GET,
      "api/v1/pleroma/chats/$id/messages",
      (j) => PleromaChatMessage.fromJson(j)
    );
  }

  Future<PleromaChatMessage> postChatMessage(String id, String message) async {
    return await sendJsonRequest(
      HttpMethod.POST,
      "api/v1/pleroma/chats/$id/messages",
      (j) => PleromaChatMessage.fromJson(j),
      body: { "content": message },
    );
  }
}