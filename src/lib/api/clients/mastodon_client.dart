import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaiteki/api/api_type.dart';

import 'package:kaiteki/api/responses/mastodon/login_response.dart';
import 'package:kaiteki/api/clients/fediverse_client_base.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/api/model/mastodon/account.dart';
import 'package:kaiteki/api/model/mastodon/application.dart';
import 'package:kaiteki/api/model/mastodon/instance.dart';
import 'package:kaiteki/api/model/mastodon/notification.dart';
import 'package:kaiteki/api/model/mastodon/status.dart';
import 'package:kaiteki/utils/utils.dart';
import 'package:kaiteki/utils/string_extensions.dart';

class MastodonClient extends FediverseClientBase {
  @override
  ApiType get type => ApiType.Mastodon;

  Future<MastodonInstance> getInstance() async {
    var response = await http.get("$baseUrl/api/v1/instance");
    Utils.checkResponse(response);
    var jsonObject = jsonDecode(response.body);

    return MastodonInstance.fromJson(jsonObject);
  }

  Future<MastodonAccount> getAccount(String id) async {
    var response = await http.get("$baseUrl/api/v1/accounts/$id");
    Utils.checkResponse(response);

    var jsonObject = jsonDecode(response.body);

    return MastodonAccount.fromJson(jsonObject);
  }

  Future<Iterable<MastodonStatus>> getStatuses(String id) async {
    var response = await http.get("$baseUrl/api/v1/accounts/$id/statuses");
    Utils.checkResponse(response);

    var jsonObject = jsonDecode(response.body);
    var statuses = jsonObject.map<MastodonStatus>((j) => MastodonStatus.fromJson(j));
    return statuses;
  }

  Future<LoginResponse> login(String username, String password) async {
    var body = <String, String> {
      "username": username,
      "password" : password,
      "grant_type": "password",
      "client_id": clientId,
      "client_secret": clientSecret
    };

    var response = await http.post(
      "$baseUrl/oauth/token",
      body: body,
      headers: getHeaders()
    );

    Utils.checkResponse(response);

    var json = jsonDecode(response.body);
    return LoginResponse.fromJson(json);
  }

  Future<LoginResponse> respondMfa(String mfaToken, int code) async {
    var body = <String, String> {
      "mfa_token": mfaToken,
      "code": code.toString(),
      "challenge_type": "totp",
      "client_id": clientId,
      "client_secret": clientSecret
    };

    var response = await http.post(
      "$baseUrl/oauth/mfa/challenge",
      body: body,
      headers: getHeaders()
    );

    Utils.checkResponse(response);

    var json = jsonDecode(response.body);
    return LoginResponse.fromJson(json);
  }

  Future<MastodonAccount> verifyCredentials() async {
    var response = await http.get(
      "$baseUrl/api/v1/accounts/verify_credentials",
      headers: getHeaders()
    );

    Utils.checkResponse(response);

    if (response.statusCode != 200)
      return null;

    var json = jsonDecode(response.body);
    return MastodonAccount.fromJson(json);
  }

  Future<MastodonApplication> createApplication(
    String instance,
    String clientName,
    String website,
    String redirect,
    List<String> scopes
  ) async {
    var body = <String, String> {
      "client_name": clientName,
      "website": website,
      "redirect_uris": redirect,
      "scopes": scopes.join(" ")
    };

    var response = await http.post(
      "https://$instance/api/v1/apps",
      body: body,
      headers: getHeaders()
    );

    Utils.checkResponse(response);

    var json = jsonDecode(response.body);
    return MastodonApplication.fromJson(json);
  }

  Future<Iterable<MastodonStatus>> getPublicTimeline() async {
    var response = await http.get(
      "$baseUrl/api/v1/timelines/public",
      headers: getHeaders()
    );

    Utils.checkResponse(response);

    var json = jsonDecode(response.body);
    return json.map<MastodonStatus>((j) => MastodonStatus.fromJson(j));
  }

  Future<Iterable<MastodonStatus>> getTimeline() async {
    var response = await http.get(
      "$baseUrl/api/v1/timelines/home",
      headers: getHeaders()
    );

    Utils.checkResponse(response);

    var json = jsonDecode(response.body);
    return json.map<MastodonStatus>((j) => MastodonStatus.fromJson(j));
  }

  Future<MastodonStatus> postStatus(String status, {String spoilerText, String contentType}) async {
    var body = <String, String> {
      "status": status,
      "source": Constants.appName,
      "spoiler_text": spoilerText,
      "content_type": contentType,
      //"visibility": "public"
    };

    var response = await http.post(
      "$baseUrl/api/v1/statuses",
      body: jsonEncode(body),
      headers: getHeaders(contentType: "application/json")
    );

    Utils.checkResponse(response);

    var json = jsonDecode(response.body);
    return MastodonStatus.fromJson(json);
  }

  Future<Iterable<MastodonNotification>> getNotifications() async {
    var response = await http.get(
      "$baseUrl/api/v1/notifications",
      headers: getHeaders()
    );

    Utils.checkResponse(response);

    var json = jsonDecode(response.body);
    return json.map<MastodonNotification>((j) => MastodonNotification.fromJson(j));
  }
}