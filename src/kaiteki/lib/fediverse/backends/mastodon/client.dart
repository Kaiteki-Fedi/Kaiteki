import 'package:fediverse_objects/mastodon.dart' as mastodon;
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/backends/mastodon/responses/context.dart';
import 'package:kaiteki/fediverse/backends/mastodon/responses/login.dart';
import 'package:kaiteki/fediverse/client_base.dart';
import 'package:kaiteki/http/response.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/authentication_data.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/model/file.dart';
import 'package:kaiteki/model/http_method.dart';
import 'package:kaiteki/utils/utils.dart';

class MastodonClient extends FediverseClientBase<MastodonAuthenticationData> {
  @override
  ApiType get type => ApiType.mastodon;

  Future<mastodon.Instance> getInstance() async {
    return sendJsonRequest(
      HttpMethod.get,
      "api/v1/instance",
      mastodon.Instance.fromJson,
    );
  }

  Future<mastodon.Account> getAccount(String id) async {
    return sendJsonRequest(
      HttpMethod.get,
      "api/v1/accounts/$id",
      mastodon.Account.fromJson,
    );
  }

  Future<Iterable<mastodon.Status>> getStatuses(String id) async {
    return sendJsonRequestMultiple(
      HttpMethod.get,
      "api/v1/accounts/$id/statuses",
      mastodon.Status.fromJson,
    );
  }

  /// This method does not error-check on its own!
  Future<LoginResponse> login(String username, String password) async {
    return sendJsonRequest(
      HttpMethod.post,
      "oauth/token",
      LoginResponse.fromJson,
      body: {
        "username": username,
        "password": password,
        "grant_type": "password",
        "client_id": authenticationData!.clientId,
        "client_secret": authenticationData!.clientSecret,
      },
    );
  }

  Future<LoginResponse> getToken(
    String grantType,
    String clientId,
    String clientSecret,
    String redirectUri, {
    String? scope,
    String? code,
  }) async {
    return sendJsonRequest(
      HttpMethod.post,
      "oauth/token",
      LoginResponse.fromJson,
      body: {
        "grant_type": grantType,
        "client_id": clientId,
        "client_secret": clientSecret,
        "redirect_uri": redirectUri,
        if (scope != null) "scope": scope,
        if (code != null) "code": code,
      },
    );
  }

  Future<LoginResponse> respondMfa(String mfaToken, int code) async {
    return sendJsonRequest(
      HttpMethod.post,
      "/oauth/mfa/challenge",
      LoginResponse.fromJson,
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
      mastodon.Emoji.fromJson,
    );
  }

  Future<mastodon.Account> verifyCredentials() async {
    return sendJsonRequest(
      HttpMethod.get,
      "api/v1/accounts/verify_credentials",
      mastodon.Account.fromJson,
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
      mastodon.Application.fromJson,
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
      mastodon.Status.fromJson,
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
      mastodon.Status.fromJson,
    );
  }

  Future<mastodon.Status> postStatus(
    String status, {
    String? spoilerText,
    bool? pleromaPreview,
    String? visibility,
    String? inReplyToId,
    String? contentType = "text/plain",
    List<String> mediaIds = const [],
  }) async {
    return sendJsonRequest(
      HttpMethod.post,
      "api/v1/statuses",
      mastodon.Status.fromJson,
      body: {
        "status": status,
        "source": consts.appName,
        "spoiler_text": spoilerText ?? "",
        "content_type": contentType,
        "preview": pleromaPreview.toString(),
        "visibility": visibility,
        "in_reply_to_id": inReplyToId,
        "media_ids": mediaIds
      },
    );
  }

  Future<Iterable<mastodon.Notification>> getNotifications() {
    return sendJsonRequestMultiple(
      HttpMethod.get,
      "api/v1/notifications",
      mastodon.Notification.fromJson,
    );
  }

  Future<ContextResponse> getStatusContext(String id) {
    return sendJsonRequest(
      HttpMethod.get,
      "api/v1/statuses/$id/context",
      ContextResponse.fromJson,
    );
  }

  Future<mastodon.Status> favouriteStatus(String id) async {
    return sendJsonRequest(
      HttpMethod.post,
      "api/v1/statuses/$id/favourite",
      mastodon.Status.fromJson,
    );
  }

  Future<mastodon.Status> getStatus(String id) async {
    return sendJsonRequest(
      HttpMethod.get,
      "api/v1/statuses/$id",
      mastodon.Status.fromJson,
    );
  }

  Future<mastodon.Status> unfavouriteStatus(String id) async {
    return sendJsonRequest(
      HttpMethod.post,
      "api/v1/statuses/$id/unfavourite",
      mastodon.Status.fromJson,
    );
  }

  Future<mastodon.Status> reblogStatus(String id) async {
    return sendJsonRequest(
      HttpMethod.post,
      "api/v1/statuses/$id/reblog",
      mastodon.Status.fromJson,
    );
  }

  Future<mastodon.Status> unreblogStatus(String id) async {
    return sendJsonRequest(
      HttpMethod.post,
      "api/v1/statuses/$id/unreblog",
      mastodon.Status.fromJson,
    );
  }

  Future<Iterable<mastodon.Status>> getBookmarkedStatuses() async {
    return sendJsonRequestMultiple(
      HttpMethod.get,
      "api/v1/bookmarks",
      mastodon.Status.fromJson,
    );
  }

  Future<mastodon.Status> bookmarkStatus(String id) async {
    return sendJsonRequest(
      HttpMethod.post,
      "api/v1/statuses/$id/bookmark",
      mastodon.Status.fromJson,
    );
  }

  Future<mastodon.Status> unbookmarkStatus(String id) async {
    return sendJsonRequest(
      HttpMethod.post,
      "api/v1/statuses/$id/unbookmark",
      mastodon.Status.fromJson,
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

  Future<mastodon.Attachment> uploadMedia(
    File file,
    String? description,
  ) async {
    return sendJsonMultiPartRequest(
      HttpMethod.post,
      "api/v1/media",
      mastodon.Attachment.fromJson,
      fields: {
        if (description != null) "description": description,
      },
      files: [await file.toMultipartFile("file")],
    );
  }
}
