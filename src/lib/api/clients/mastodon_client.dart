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

  Future<Instance> getInstance() async {
    var response = await http.get("$baseUrl/api/v1/instance");
    Utils.checkResponse(response);
    var jsonObject = jsonDecode(response.body);

    return Instance.fromJson(jsonObject);
  }

  Future<Account> getAccount(String id) async {
    var response = await http.get("$baseUrl/api/v1/accounts/$id");
    Utils.checkResponse(response);

    var jsonObject = jsonDecode(response.body);

    return Account.fromJson(jsonObject);
  }

  Future<Iterable<Status>> getStatuses(String id) async {
    var response = await http.get("$baseUrl/api/v1/accounts/$id/statuses");
    Utils.checkResponse(response);

    var jsonObject = jsonDecode(response.body);
    var statuses = jsonObject.map<Status>((j) => Status.fromJson(j));
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

  Future<Account> verifyCredentials() async {
    var response = await http.get(
      "$baseUrl/api/v1/accounts/verify_credentials",
      headers: getHeaders()
    );

    Utils.checkResponse(response);

    if (response.statusCode != 200)
      return null;

    var json = jsonDecode(response.body);
    return Account.fromJson(json);
  }

  Future<Application> createApplication(
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
    return Application.fromJson(json);
  }

  Future<Iterable<Status>> getPublicTimeline() async {
    var response = await http.get(
      "$baseUrl/api/v1/timelines/public",
      headers: getHeaders()
    );

    Utils.checkResponse(response);

    var json = jsonDecode(response.body);
    return json.map<Status>((j) => Status.fromJson(j));
  }

  Future<Iterable<Status>> getTimeline() async {
    var response = await http.get(
      "$baseUrl/api/v1/timelines/home",
      headers: getHeaders()
    );

    Utils.checkResponse(response);

    var json = jsonDecode(response.body);
    return json.map<Status>((j) => Status.fromJson(j));
  }

  Future<Status> postStatus(String status, {String spoilerText, String contentType}) async {
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
    return Status.fromJson(json);
  }

  Future<Iterable<Notification>> getNotifications() async {
    var response = await http.get(
      "$baseUrl/api/v1/notifications",
      headers: getHeaders()
    );

    Utils.checkResponse(response);

    var json = jsonDecode(response.body);
    return json.map<Notification>((j) => Notification.fromJson(j));
  }
}