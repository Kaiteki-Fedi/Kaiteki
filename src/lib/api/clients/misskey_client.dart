import 'dart:convert';

import 'package:kaiteki/api/api_type.dart';
import 'package:kaiteki/api/clients/fediverse_client_base.dart';
import 'package:kaiteki/api/model/misskey/pages/page.dart';
import 'package:kaiteki/api/model/misskey/user.dart';
import 'package:kaiteki/api/responses/misskey/create_app_response.dart';
import 'package:kaiteki/api/responses/misskey/generate_session_response.dart';
import 'package:kaiteki/api/responses/misskey/signin_response.dart';
import 'package:kaiteki/api/responses/misskey/userkey_response.dart';
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
      "$baseUrl/api/app/create",
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
      "$baseUrl/api/auth/session/generate",
      body: jsonEncode(body),
      headers: getHeaders()
    );

    Utils.checkResponse(response);

    var json = jsonDecode(response.body);
    return MisskeyGenerateSessionResponse.fromJson(json);
  }

  Future<MisskeyPage> getPage(String i, String username, String name) async {
    var body = {
      "i": i,
      "username": username,
      "name": name,
    };

    var response = await http.post(
        "$baseUrl/api/pages/show",
        body: jsonEncode(body),
        headers: getHeaders()
    );

    Utils.checkResponse(response);

    var json = jsonDecode(response.body);
    return MisskeyPage.fromJson(json);
  }

  Future<MisskeyUserkeyResponse> userkey(String appSecret, String token) async {
    var body = {"appSecret": appSecret, "token": token};

    var response = await http.post(
      "$baseUrl/api/auth/session/userkey",
      body: jsonEncode(body),
      headers: getHeaders()
    );

    Utils.checkResponse(response);

    var json = jsonDecode(response.body);
    return MisskeyUserkeyResponse.fromJson(json);
  }

  Future<MisskeyUser> showUser(String userId) async {
    var body = {"userId": userId};

    var response = await http.post(
      "$baseUrl/api/users/show",
      body: jsonEncode(body),
      headers: getHeaders(),
    );

    Utils.checkResponse(response);

    var json = jsonDecode(response.body);
    return MisskeyUser.fromJson(json);
  }

  Future<MisskeySignInResponse> signIn(
    String username,
    String password,
    {String token,}
  ) async {
    var body = {
      "username": username,
      "password": password
    };

    if (token != null)
      body["token"] = token;

    var response = await http.post(
      "$baseUrl/api/signin",
      body: jsonEncode(body),
      headers: getHeaders()
    );

    Utils.checkResponse(response);

    var json = jsonDecode(response.body);
    return MisskeySignInResponse.fromJson(json);
  }
}