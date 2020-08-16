import 'dart:convert';

import 'package:kaiteki/api/api_type.dart';
import 'package:kaiteki/api/clients/fediverse_client_base.dart';
import 'package:kaiteki/api/responses/misskey/misskey_create_app_response.dart';
import 'package:kaiteki/utils/utils.dart';
import 'package:http/http.dart' as http;

class MisskeyClient extends FediverseClientBase {
  @override
  ApiType get type => ApiType.Misskey;

  Future<MisskeyCreateAppResponse> createApp(
    String name,
    String description,
    List<String> permissions,
    {String callbackUrl}
  ) async {
    var body = {
      "name": name,
      "description": description,
      "permission": permissions,
      "callbackUrl": callbackUrl
    };

    var response = await http.post(
      "$baseUrl/app/create",
      body: jsonEncode(body),
      headers: getHeaders()
    );
    Utils.checkResponse(response);

    var json = jsonDecode(response.body);
    return MisskeyCreateAppResponse.fromJson(json);
  }

  Future<MisskeyGenerateSessionResponse> generateSession(String appSecret) async {
    var body = {"appSecret": appSecret};

    var response = await http.post(
      "$baseUrl/auth/session/generate",
      body: jsonEncode(body),
      headers: getHeaders()
    );

    Utils.checkResponse(response);

    var json = jsonDecode(response.body);
    return MisskeyGenerateSessionResponse.fromJson(json);
  }
}

class MisskeyGenerateSessionResponse {
  String token;
  String url;

  MisskeyGenerateSessionResponse.fromJson(Map<String, dynamic> json) {
    token = json["token"];
    url = json["url"];
  }
}