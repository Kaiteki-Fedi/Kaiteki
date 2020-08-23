import 'dart:convert';

import 'package:kaiteki/api/api_type.dart';
import 'package:kaiteki/api/clients/mastodon_client.dart';
import 'package:kaiteki/api/model/mastodon/status.dart';
import 'package:kaiteki/api/model/pleroma/chat.dart';
import 'package:kaiteki/api/model/pleroma/chat_message.dart';
import 'package:http/http.dart' as http;
import 'package:kaiteki/utils/utils.dart';

class PleromaClient extends MastodonClient {
  @override
  ApiType get type => ApiType.Pleroma;

  Future<Iterable<PleromaChat>> getChats() async {
    var response = await http.get(
      "$baseUrl/api/v1/pleroma/chats",
      headers: getHeaders()
    );
    Utils.checkResponse(response);

    var json = jsonDecode(response.body);
    var chats = json.map<PleromaChat>((o) => PleromaChat.fromJson(o));
    return chats;
  }

  Future<Iterable<PleromaChatMessage>> getChatMessages(String id) async {
    var response = await http.get(
      "$baseUrl/api/v1/pleroma/chats/$id/messages",
      headers: getHeaders()
    );

    Utils.checkResponse(response);

    var json = jsonDecode(response.body);
    var messages = json.map<PleromaChatMessage>((o) => PleromaChatMessage.fromJson(o));
    return messages;
  }

  Future<MastodonStatus> getPreview(String statusText, String contentType, String visibility) async {
    //var response = await http.get(
    //    "$baseUrl/api/v1/pleroma/chats/$id/messages",
    //    headers: getHeaders()
    //);

    //Utils.checkResponse(response);

    //var json = jsonDecode(response.body);
    //var messages = json.map<PleromaChatMessage>((o) => PleromaChatMessage.fromJson(o));
    //return messages;
  }

  Future<PleromaChatMessage> postChatMessage(String id, String message) async {
    var body = { "content": message };
    var response = await http.post(
      "$baseUrl/api/v1/pleroma/chats/$id/messages",
      body: jsonEncode(body),
      headers: getHeaders(contentType: "application/json"),
    );
    Utils.checkResponse(response);

    var json = jsonDecode(response.body);

    return PleromaChatMessage.fromJson(json);
  }
}