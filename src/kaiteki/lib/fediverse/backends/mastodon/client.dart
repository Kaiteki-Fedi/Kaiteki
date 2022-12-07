import 'dart:convert';

import 'package:fediverse_objects/mastodon.dart';
import 'package:http/http.dart' show Response;
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/exceptions/api_exception.dart';
import 'package:kaiteki/fediverse/backends/mastodon/models/search.dart';
import 'package:kaiteki/fediverse/backends/mastodon/responses/context.dart';
import 'package:kaiteki/fediverse/backends/mastodon/responses/login.dart';
import 'package:kaiteki/fediverse/backends/mastodon/responses/marker.dart';
import 'package:kaiteki/http/http.dart';
import 'package:kaiteki/model/file.dart';

class MastodonClient {
  late final KaitekiClient client;

  String? accessToken;

  MastodonClient(String instance) {
    client = KaitekiClient(
      baseUri: Uri(scheme: "https", host: instance),
      checkResponse: checkResponse,
      intercept: (request) {
        if (accessToken == null) return;
        request.headers["Authorization"] = "Bearer $accessToken";
      },
    );
  }

  Future<Instance> getInstance() async => client
      .sendRequest(HttpMethod.get, "api/v1/instance")
      .then(Instance.fromJson.fromResponse);

  Future<Account> getAccount(String id) async => client
      .sendRequest(HttpMethod.get, "api/v1/accounts/$id")
      .then(Account.fromJson.fromResponse);

  Future<List<Status>> getStatuses(
    String id, {
    String? minId,
    String? maxId,
  }) async {
    return client.sendRequest(
      HttpMethod.get,
      "api/v1/accounts/$id/statuses",
      query: {
        if (minId != null) "min_id": minId,
        if (maxId != null) "max_id": maxId,
      },
    ).then(Status.fromJson.fromResponseList);
  }

  /// This method does not error-check on its own!
  Future<LoginResponse> login(
    String username,
    String password,
    String clientId,
    String clientSecret,
  ) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "oauth/token",
          body: {
            "username": username,
            "password": password,
            "grant_type": "password",
            "client_id": clientId,
            "client_secret": clientSecret,
          }.jsonBody,
        )
        .then(LoginResponse.fromJson.fromResponse);
  }

  Future<LoginResponse> getToken(
    String grantType,
    String clientId,
    String clientSecret,
    String redirectUri, {
    String? scope,
    String? code,
  }) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "oauth/token",
          body: {
            "grant_type": grantType,
            "client_id": clientId,
            "client_secret": clientSecret,
            "redirect_uri": redirectUri,
            if (scope != null) "scope": scope,
            if (code != null) "code": code,
          }.jsonBody,
        )
        .then(LoginResponse.fromJson.fromResponse);
  }

  Future<LoginResponse> respondMfa(
    String mfaToken,
    int code,
    String clientId,
    String clientSecret,
  ) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "/oauth/mfa/challenge",
          body: {
            "mfa_token": mfaToken,
            "code": code.toString(),
            "challenge_type": "totp",
            "client_id": clientId,
            "client_secret": clientSecret,
          }.jsonBody,
        )
        .then(LoginResponse.fromJson.fromResponse);
  }

  Future<List<Emoji>> getCustomEmojis() async => client
      .sendRequest(HttpMethod.get, "api/v1/custom_emojis")
      .then(Emoji.fromJson.fromResponseList);

  Future<Account> verifyCredentials() async => client
      .sendRequest(HttpMethod.get, "api/v1/accounts/verify_credentials")
      .then(Account.fromJson.fromResponse);

  Future<Application> createApplication(
    String instance,
    String clientName,
    String website,
    String redirect,
    List<String> scopes,
  ) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/v1/apps",
          body: {
            "client_name": clientName,
            "website": website,
            "redirect_uris": redirect,
            "scopes": scopes.join(" "),
          }.jsonBody,
        )
        .then(Application.fromJson.fromResponse);
  }

  Future<List<Status>> getHomeTimeline({
    bool? local,
    bool? remote,
    bool? onlyMedia,
    String? maxId,
    String? sinceId,
    String? minId,
    int? limit,
  }) async {
    return client.sendRequest(
      HttpMethod.get,
      "api/v1/timelines/home",
      query: {
        'local': local,
        'remote': remote,
        'only_media': onlyMedia,
        'max_id': maxId,
        'since_id': sinceId,
        'min_id': minId,
        'limit': limit,
      },
    ).then(Status.fromJson.fromResponseList);
  }

  Future<List<Status>> getPublicTimeline({
    bool? local,
    bool? remote,
    bool? onlyMedia,
    String? maxId,
    String? sinceId,
    String? minId,
    int? limit,
  }) async {
    return client.sendRequest(
      HttpMethod.get,
      "api/v1/timelines/public",
      query: {
        'local': local,
        'remote': remote,
        'only_media': onlyMedia,
        'max_id': maxId,
        'since_id': sinceId,
        'min_id': minId,
        'limit': limit,
      },
    ).then(Status.fromJson.fromResponseList);
  }

  Future<Status> postStatus(
    String status, {
    String? spoilerText,
    bool? pleromaPreview,
    String? visibility,
    String? inReplyToId,
    String? contentType = "text/plain",
    List<String> mediaIds = const [],
  }) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/v1/statuses",
          body: {
            "status": status,
            "source": consts.appName,
            "spoiler_text": spoilerText ?? "",
            "content_type": contentType,
            "preview": pleromaPreview.toString(),
            "visibility": visibility,
            "in_reply_to_id": inReplyToId,
            "media_ids": mediaIds
          }.jsonBody,
        )
        .then(Status.fromJson.fromResponse);
  }

  Future<List<Notification>> getNotifications() => client
      .sendRequest(HttpMethod.get, "api/v1/notifications")
      .then(Notification.fromJson.fromResponseList);

  Future<ContextResponse> getStatusContext(String id) => client
      .sendRequest(HttpMethod.get, "api/v1/statuses/$id/context")
      .then(ContextResponse.fromJson.fromResponse);

  Future<Status> favouriteStatus(String id) async => client
      .sendRequest(HttpMethod.post, "api/v1/statuses/$id/favourite")
      .then(Status.fromJson.fromResponse);

  Future<Status> getStatus(String id) async => client
      .sendRequest(HttpMethod.get, "api/v1/statuses/$id")
      .then(Status.fromJson.fromResponse);

  Future<Status> unfavouriteStatus(String id) async => client
      .sendRequest(HttpMethod.post, "api/v1/statuses/$id/unfavourite")
      .then(Status.fromJson.fromResponse);

  Future<Status> reblogStatus(String id) async => client
      .sendRequest(HttpMethod.post, "api/v1/statuses/$id/reblog")
      .then(Status.fromJson.fromResponse);

  Future<Status> unreblogStatus(String id) async => client
      .sendRequest(HttpMethod.post, "api/v1/statuses/$id/unreblog")
      .then(Status.fromJson.fromResponse);

  Future<Iterable<Status>> getBookmarkedStatuses({
    String? maxId,
    String? sinceId,
    String? minId,
    int? limit,
  }) async {
    return client.sendRequest(
      HttpMethod.get,
      "api/v1/bookmarks",
      query: {
        'max_id': maxId,
        'since_id': sinceId,
        'min_id': minId,
        'limit': limit,
      },
    ).then(Status.fromJson.fromResponseList);
  }

  Future<Status> bookmarkStatus(String id) async => client
      .sendRequest(HttpMethod.post, "api/v1/statuses/$id/bookmark")
      .then(Status.fromJson.fromResponse);

  Future<Status> unbookmarkStatus(String id) async => client
      .sendRequest(HttpMethod.post, "api/v1/statuses/$id/unbookmark")
      .then(Status.fromJson.fromResponse);

  void checkResponse(Response response) {
    if (response.isSuccessful) return;

    dynamic json;

    try {
      json = jsonDecode(response.body);
    } catch (_) {}

    if (json != null) {
      throw ApiException(
        response.statusCode,
        reasonPhrase: json["error"] as String,
        data: json,
      );
    }
  }

  Future<Attachment> uploadMedia(
    File file,
    String? description,
  ) async {
    return client.sendMultipartRequest(
      HttpMethod.post,
      "api/v1/media",
      fields: {if (description != null) "description": description},
      files: [await file.toMultipartFile("file")],
    ).then(Attachment.fromJson.fromResponse);
  }

  Future<List<Account>> getFavouritedBy(String statusId) async => client
      .sendRequest(HttpMethod.get, "api/v1/statuses/$statusId/favourited_by")
      .then(Account.fromJson.fromResponseList);

  Future<List<Account>> getBoostedBy(String statusId) async => client
      .sendRequest(HttpMethod.get, "api/v1/statuses/$statusId/reblogged_by")
      .then(Account.fromJson.fromResponseList);

  Future<MarkerResponse> getMarkers(Set<MarkerTimeline> timeline) async {
    // HACK(Craftplacer): query might be wrong
    return client
        .sendRequest(
          HttpMethod.get,
          "api/v1/markers?timeline[]=${timeline.map((t) => t.name).join(",")}",
        )
        .then(MarkerResponse.fromJson.fromResponse);
  }

  Future<Search> search(
    String query, {
    String? type,
    int? offset,
    String? maxId,
    String? minId,
    bool? resolve,
  }) async {
    return client.sendRequest(
      HttpMethod.get,
      "api/v2/search",
      query: {
        "q": query,
        "offset": offset,
        "max_id": maxId,
        "min_id": minId,
        "resolve": resolve,
      },
    ).then(Search.fromJson.fromResponse);
  }

  Future<List<Account>> searchAccounts(
    String q, {
    bool? resolve,
    bool? following,
  }) {
    return client.sendRequest(
      HttpMethod.get,
      "api/v1/accounts/search",
      query: {
        "q": q,
        "resolve": resolve,
        "following": following,
      },
    ).then(Account.fromJson.fromResponseList);
  }
}
