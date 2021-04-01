import 'package:fediverse_objects/mastodon.dart';
import 'package:http/http.dart' as http;
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/fediverse/api/api_type.dart';
import 'package:kaiteki/fediverse/api/clients/fediverse_client_base.dart';
import 'package:kaiteki/fediverse/api/responses/mastodon/context_response.dart';
import 'package:kaiteki/fediverse/api/responses/mastodon/login_response.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/authentication_data.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/model/http_method.dart';
import 'package:kaiteki/utils/utils.dart';

class MastodonClient extends FediverseClientBase<MastodonAuthenticationData> {
  @override
  ApiType get type => ApiType.Mastodon;

  Future<MastodonInstance> getInstance() async {
    return await sendJsonRequest(
      HttpMethod.POST,
      "api/v1/instance",
      (j) => MastodonInstance.fromJson(j),
    );
  }

  Future<MastodonAccount> getAccount(String id) async {
    return await sendJsonRequest(
      HttpMethod.GET,
      "api/v1/accounts/$id",
      (j) => MastodonAccount.fromJson(j),
    );
  }

  Future<Iterable<MastodonStatus>> getStatuses(String id) async {
    return await sendJsonRequestMultiple(
      HttpMethod.GET,
      "api/v1/accounts/$id/statuses",
      (j) => MastodonStatus.fromJson(j),
    );
  }

  /// This method does not error-check on its own!
  Future<LoginResponse> login(String username, String password) async {
    return await sendJsonRequest(
      HttpMethod.POST,
      "oauth/token",
      (j) => LoginResponse.fromJson(j),
      body: {
        "username": username,
        "password": password,
        "grant_type": "password",
        "client_id": authenticationData!.clientId,
        "client_secret": authenticationData!.clientSecret,
      },
    );
  }

  Future<LoginResponse> respondMfa(String mfaToken, int code) async {
    return await sendJsonRequest(
      HttpMethod.POST,
      "/oauth/mfa/challenge",
      (j) => LoginResponse.fromJson(j),
      body: {
        "mfa_token": mfaToken,
        "code": code.toString(),
        "challenge_type": "totp",
        "client_id": authenticationData!.clientId,
        "client_secret": authenticationData!.clientSecret,
      },
    );
  }

  Future<Iterable<MastodonEmoji>> getCustomEmojis() async {
    return await sendJsonRequestMultiple(
      HttpMethod.GET,
      "api/v1/custom_emojis",
      (json) => MastodonEmoji.fromJson(json),
    );
  }

  Future<MastodonAccount> verifyCredentials() async {
    return await sendJsonRequest(
      HttpMethod.GET,
      "api/v1/accounts/verify_credentials",
      (json) => MastodonAccount.fromJson(json),
    );
  }

  Future<MastodonApplication> createApplication(
      String instance,
      String clientName,
      String website,
      String redirect,
      List<String> scopes) async {
    return await sendJsonRequest(
      HttpMethod.POST,
      "api/v1/apps",
      (json) => MastodonApplication.fromJson(json),
      body: {
        "client_name": clientName,
        "website": website,
        "redirect_uris": redirect,
        "scopes": scopes.join(" "),
      },
    );
  }

  Future<Iterable<MastodonStatus>> getPublicTimeline() async {
    return await sendJsonRequestMultiple(
      HttpMethod.GET,
      "api/v1/timelines/public",
      (j) => MastodonStatus.fromJson(j),
    );
  }

  Future<Iterable<MastodonStatus>> getTimeline({
    bool? local,
    bool? remote,
    bool? onlyMedia,
    String? maxId,
    String? sinceId,
    String? minId,
    int? limit,
  }) async {
    var queryParams = {
      'local': local,
      'remote': remote,
      'only_media': onlyMedia,
      'max_id': maxId,
      'since_id': sinceId,
      'min_id': minId,
      'limit': limit,
    };

    return await sendJsonRequestMultiple(
      HttpMethod.GET,
      Utils.withQueries("api/v1/timelines/home", queryParams),
      (j) => MastodonStatus.fromJson(j),
    );
  }

  Future<MastodonStatus> postStatus(
    String status, {
    String? spoilerText,
    String? contentType,
    bool? pleromaPreview,
  }) async {
    return await sendJsonRequest(
      HttpMethod.POST,
      "api/v1/statuses",
      (j) => MastodonStatus.fromJson(j),
      body: {
        "status": status,
        "source": Constants.appName,
        "spoiler_text": spoilerText,
        "content_type": contentType,
        "preview": pleromaPreview.toString(),
        //"visibility": "public"
      },
    );
  }

  Future<Iterable<MastodonNotification>> getNotifications() async {
    return await sendJsonRequestMultiple(
      HttpMethod.GET,
      "api/v1/notifications",
      (j) => MastodonNotification.fromJson(j),
    );
  }

  Future<ContextResponse> getContext(String id) async {
    return await sendJsonRequest(
      HttpMethod.GET,
      "api/v1/statuses/$id/context",
      (j) => ContextResponse.fromJson(j),
    );
  }

  @override
  void checkResponse(http.StreamedResponse response) {}

  @override
  Future<void> setClientAuthentication(ClientSecret secret) {
    instance = secret.instance;
    authenticationData = MastodonAuthenticationData(
      secret.clientId,
      secret.clientSecret,
    );
    return Future.value();
  }

  @override
  Future<void> setAccountAuthentication(AccountSecret secret) {
    instance = secret.instance;
    authenticationData!.accessToken = secret.accessToken;
    return Future.value();
  }
}
