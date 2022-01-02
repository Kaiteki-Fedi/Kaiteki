import 'package:fediverse_objects/mastodon.dart' as mastodon;
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/backends/mastodon/responses/context.dart';
import 'package:kaiteki/fediverse/backends/mastodon/responses/login.dart';
import 'package:kaiteki/fediverse/client_base.dart';
import 'package:kaiteki/http/response.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/authentication_data.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/model/http_method.dart';
import 'package:kaiteki/utils/utils.dart';

class MastodonClient extends FediverseClientBase<MastodonAuthenticationData> {
  @override
  ApiType get type => ApiType.mastodon;

  Future<mastodon.Instance> getInstance() async {
    return sendJsonRequest(
      HttpMethod.get,
      "api/v1/instance",
      (j) => mastodon.Instance.fromJson(j),
    );
  }

  Future<mastodon.Account> getAccount(String id) async {
    return sendJsonRequest(
      HttpMethod.get,
      "api/v1/accounts/$id",
      (j) => mastodon.Account.fromJson(j),
    );
  }

  Future<Iterable<mastodon.Status>> getStatuses(String id) async {
    return sendJsonRequestMultiple(
      HttpMethod.get,
      "api/v1/accounts/$id/statuses",
      (j) => mastodon.Status.fromJson(j),
    );
  }

  /// This method does not error-check on its own!
  Future<LoginResponse> login(String username, String password) async {
    return sendJsonRequest(
      HttpMethod.post,
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
    return sendJsonRequest(
      HttpMethod.post,
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

  Future<Iterable<mastodon.Emoji>> getCustomEmojis() async {
    return sendJsonRequestMultiple(
      HttpMethod.get,
      "api/v1/custom_emojis",
      (json) => mastodon.Emoji.fromJson(json),
    );
  }

  Future<mastodon.Account> verifyCredentials() async {
    return sendJsonRequest(
      HttpMethod.get,
      "api/v1/accounts/verify_credentials",
      (json) => mastodon.Account.fromJson(json),
    );
  }

  Future<mastodon.Application> createApplication(
    String instance,
    String clientName,
    String website,
    String redirect,
    List<String> scopes,
  ) async {
    return sendJsonRequest(
      HttpMethod.post,
      "api/v1/apps",
      (json) => mastodon.Application.fromJson(json),
      body: {
        "client_name": clientName,
        "website": website,
        "redirect_uris": redirect,
        "scopes": scopes.join(" "),
      },
    );
  }

  Future<Iterable<mastodon.Status>> getPublicTimeline() async {
    return sendJsonRequestMultiple(
      HttpMethod.get,
      "api/v1/timelines/public",
      (j) => mastodon.Status.fromJson(j),
    );
  }

  Future<Iterable<mastodon.Status>> getTimeline({
    bool? local,
    bool? remote,
    bool? onlyMedia,
    String? maxId,
    String? sinceId,
    String? minId,
    int? limit,
  }) async {
    final queryParams = {
      'local': local,
      'remote': remote,
      'only_media': onlyMedia,
      'max_id': maxId,
      'since_id': sinceId,
      'min_id': minId,
      'limit': limit,
    };

    return sendJsonRequestMultiple(
      HttpMethod.get,
      withQueries("api/v1/timelines/home", queryParams),
      (j) => mastodon.Status.fromJson(j),
    );
  }

  Future<mastodon.Status> postStatus(
    String status, {
    String? spoilerText,
    bool? pleromaPreview,
    String? visibility,
    String? inReplyToId,
    String? contentType = "text/plain",
  }) async {
    return sendJsonRequest(
      HttpMethod.post,
      "api/v1/statuses",
      (j) => mastodon.Status.fromJson(j),
      body: {
        "status": status,
        "source": Constants.appName,
        "spoiler_text": spoilerText ?? "",
        "content_type": contentType,
        "preview": pleromaPreview.toString(),
        "visibility": visibility,
        "in_reply_to_id": inReplyToId,
      },
    );
  }

  Future<Iterable<mastodon.Notification>> getNotifications() {
    return sendJsonRequestMultiple(
      HttpMethod.get,
      "api/v1/notifications",
      (j) => mastodon.Notification.fromJson(j),
    );
  }

  Future<ContextResponse> getStatusContext(String id) {
    return sendJsonRequest(
      HttpMethod.get,
      "api/v1/statuses/$id/context",
      (j) => ContextResponse.fromJson(j),
    );
  }

  Future<mastodon.Status> favouriteStatus(String id) async {
    return sendJsonRequest(
      HttpMethod.post,
      "api/v1/statuses/$id/favourite",
      (j) => mastodon.Status.fromJson(j),
    );
  }

  Future<mastodon.Status> getStatus(String id) async {
    return sendJsonRequest(
      HttpMethod.get,
      "api/v1/statuses/$id",
      (j) => mastodon.Status.fromJson(j),
    );
  }

  Future<mastodon.Status> unfavouriteStatus(String id) async {
    return sendJsonRequest(
      HttpMethod.post,
      "api/v1/statuses/$id/unfavourite",
      (j) => mastodon.Status.fromJson(j),
    );
  }

  @override
  Future<void> checkResponse(Response response) async {}

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
