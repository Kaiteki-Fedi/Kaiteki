import "dart:convert";

import "package:collection/collection.dart";
import "package:fediverse_objects/mastodon.dart" hide List;
import "package:fediverse_objects/mastodon.dart" as mastodon show List;
import "package:fediverse_objects/mastodon_v1.dart" as v1;
import "package:http/http.dart" show Response;
import "package:kaiteki/constants.dart" as consts;
import "package:kaiteki/exceptions/http_exception.dart";
import "package:kaiteki/fediverse/backends/mastodon/models/pagination.dart";
import "package:kaiteki/fediverse/backends/mastodon/models/search.dart";
import "package:kaiteki/fediverse/backends/mastodon/responses/context.dart";
import "package:kaiteki/fediverse/backends/mastodon/responses/login.dart";
import "package:kaiteki/fediverse/backends/mastodon/responses/marker.dart";
import "package:kaiteki/http/http.dart";
import "package:kaiteki/model/file.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki/utils/link_header_parser.dart";
import "package:kaiteki/utils/utils.dart";

class MastodonClient {
  late final KaitekiClient client;

  String instance;
  String? accessToken;

  MastodonClient(this.instance) {
    client = KaitekiClient(
      baseUri: Uri(scheme: "https", host: instance),
      checkResponse: checkResponse,
      intercept: (request) {
        if (accessToken == null) return;
        request.headers["Authorization"] = "Bearer $accessToken";
      },
    );
  }

  Future<v1.Instance> getInstanceV1() async => client
      .sendRequest(HttpMethod.get, "api/v1/instance")
      .then(v1.Instance.fromJson.fromResponse);

  Future<Instance> getInstance() async => client
      .sendRequest(HttpMethod.get, "api/v2/instance")
      .then(Instance.fromJson.fromResponse);

  Future<Account> getAccount(String id) async => client
      .sendRequest(HttpMethod.get, "api/v1/accounts/$id")
      .then(Account.fromJson.fromResponse);

  Future<List<Status>> getAccountStatuses(
    String id, {
    String? minId,
    String? maxId,
    bool? onlyMedia,
    bool? excludeReblogs,
    bool? excludeReplies,
    bool? pinned,
  }) async {
    return client.sendRequest(
      HttpMethod.get,
      "api/v1/accounts/$id/statuses",
      query: {
        if (minId != null) "min_id": minId,
        if (maxId != null) "max_id": maxId,
        if (onlyMedia != null) "only_media": onlyMedia,
        if (excludeReblogs != null) "exclude_reblogs": excludeReblogs,
        if (excludeReplies != null) "exclude_replies": excludeReplies,
        if (pinned != null) "pinned": pinned,
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
        "local": local,
        "remote": remote,
        "only_media": onlyMedia,
        "max_id": maxId,
        "since_id": sinceId,
        "min_id": minId,
        "limit": limit,
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
        "local": local,
        "remote": remote,
        "only_media": onlyMedia,
        "max_id": maxId,
        "since_id": sinceId,
        "min_id": minId,
        "limit": limit,
      },
    ).then(Status.fromJson.fromResponseList);
  }

  Future<List<Status>> getListTimeline(
    String listId, {
    String? maxId,
    String? sinceId,
    String? minId,
    int? limit,
  }) async {
    return client.sendRequest(
      HttpMethod.get,
      "api/v1/timelines/list/$listId",
      query: {
        "max_id": maxId,
        "since_id": sinceId,
        "min_id": minId,
        "limit": limit,
      },
    ).then(Status.fromJson.fromResponseList);
  }

  Future<Status> postStatus(
    String status, {
    String? spoilerText,
    bool? sensitive,
    bool? pleromaPreview,
    String? visibility,
    String? inReplyToId,
    String? contentType = "text/plain",
    List<String> mediaIds = const [],
    String? language,
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
            "preview": pleromaPreview,
            "visibility": visibility,
            "in_reply_to_id": inReplyToId,
            "media_ids": mediaIds,
            "sensitive": sensitive,
            "language": language,
          }.jsonBody,
        )
        .then(Status.fromJson.fromResponse);
  }

  Future<List<Notification>> getNotifications({
    String? maxId,
    String? sinceId,
    String? minId,
    int? limit,
  }) async =>
      client.sendRequest(
        HttpMethod.get,
        "api/v1/notifications",
        query: {
          "max_id": maxId,
          "since_id": sinceId,
          "min_id": minId,
          "limit": limit,
        },
      ).then(Notification.fromJson.fromResponseList);

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
        "max_id": maxId,
        "since_id": sinceId,
        "min_id": minId,
        "limit": limit,
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

    JsonMap? json;

    try {
      json = jsonDecode(response.body) as JsonMap;
    } catch (_) {}

    if (json != null) {
      throw HttpException(
        response.statusCode,
        reasonPhrase: json["error"] as String? ?? response.reasonPhrase,
      );
    }
  }

  Future<Attachment> uploadMedia(
    KaitekiFile file,
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
    return client.sendRequest(
      HttpMethod.get,
      "api/v1/markers",
      query: {"timeline": timeline.map((t) => t.name).join(",")},
    ).then(MarkerResponse.fromJson.fromResponse);
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

  Future<List<mastodon.List>> getLists() async {
    return client
        .sendRequest(HttpMethod.get, "api/v1/lists")
        .then(mastodon.List.fromJson.fromResponseList);
  }

  Future<mastodon.List> getList(String id) async {
    return client
        .sendRequest(HttpMethod.get, "api/v1/lists/$id")
        .then(mastodon.List.fromJson.fromResponse);
  }

  Future<mastodon.List> createList(
    String title, [
    RepliesPolicy? repliesPolicy,
  ]) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/v1/lists",
          body: {
            "title": title,
            if (repliesPolicy != null) "replies_policy": repliesPolicy,
          }.jsonBody,
        )
        .then(mastodon.List.fromJson.fromResponse);
  }

  Future<void> deleteList(String id) async =>
      client.sendRequest(HttpMethod.delete, "api/v1/lists/$id");

  Future<List<Account>> getListAccounts(String id) async => client
      .sendRequest(HttpMethod.get, "api/v1/lists/$id/accounts")
      .then(Account.fromJson.fromResponseList);

  Future<void> addListAccounts(String id, Set<String> accountIds) async {
    await client.sendRequest(
      HttpMethod.post,
      "api/v1/lists/$id/accounts",
      body: {"account_ids": accountIds.toList()}.jsonBody,
    );
  }

  Future<void> removeListAccounts(String id, Set<String> accountIds) async {
    await client.sendRequest(
      HttpMethod.delete,
      "api/v1/lists/$id/accounts",
      body: {"account_ids": accountIds.toList()}.jsonBody,
    );
  }

  Future<void> updateList(String id, String title) async {
    await client
        .sendRequest(
          HttpMethod.put,
          "api/v1/lists/$id",
          body: {"title": title}.jsonBody,
        )
        .then(mastodon.List.fromJson.fromResponse);
  }

  Future<List<Status>> getTrendingStatuses({
    int? limit,
    int? offset,
  }) async {
    return client
        .sendRequest(
          HttpMethod.get,
          "api/v1/trends/statuses",
          body: {
            if (limit == null) "limit": limit,
            if (offset == null) "offset": offset,
          }.jsonBody,
        )
        .then(Status.fromJson.fromResponseList);
  }

  Future<List<PreviewCard>> getTrendingLinks({
    int? limit,
    int? offset,
  }) async {
    return client
        .sendRequest(
          HttpMethod.get,
          "api/v1/trends/links",
          body: {
            if (limit == null) "limit": limit,
            if (offset == null) "offset": offset,
          }.jsonBody,
        )
        .then(PreviewCard.fromJson.fromResponseList);
  }

  Future<List<Tag>> getTrendingTags({
    int? limit,
    int? offset,
  }) async {
    return client
        .sendRequest(
          HttpMethod.get,
          "api/v1/trends/tags",
          body: {
            if (limit == null) "limit": limit,
            if (offset == null) "offset": offset,
          }.jsonBody,
        )
        .then(Tag.fromJson.fromResponseList);
  }

  Future<MastodonPagination<List<Account>>> getAccountFollowing(
    String id, {
    String? maxId,
    String? sinceId,
    String? minId,
  }) async {
    final response = await client.sendRequest(
      HttpMethod.get,
      "api/v1/accounts/$id/following",
      query: {
        if (maxId != null) "max_id": maxId,
        if (sinceId != null) "since_id": sinceId,
        if (minId != null) "min_id": minId,
      },
    );

    final accounts = Account.fromJson.fromResponseList(response);
    final linkHeader = response.headers["Link"];
    return _createPagination(accounts, linkHeader);
  }

  Future<MastodonPagination<List<Account>>> getAccountFollowers(
    String id, {
    String? maxId,
    String? sinceId,
    String? minId,
  }) async {
    final response = await client.sendRequest(
      HttpMethod.get,
      "api/v1/accounts/$id/followers",
      query: {
        if (maxId != null) "max_id": maxId,
        if (sinceId != null) "since_id": sinceId,
        if (minId != null) "min_id": minId,
      },
    );

    final accounts = Account.fromJson.fromResponseList(response);
    final linkHeader = response.headers["Link"];
    return _createPagination(accounts, linkHeader);
  }

  MastodonPagination<List<T>> _createPagination<T>(
    List<T> data,
    String? linkHeader,
  ) {
    final links = linkHeader.nullTransform(parseLinkHeader);

    final previousParams = links
        ?.firstWhereOrNull((element) => element.parameters["rel"] == '"prev"')
        ?.reference
        .queryParameters;

    final nextParams = links
        ?.firstWhereOrNull((element) => element.parameters["rel"] == '"next"')
        ?.reference
        .queryParameters;

    return MastodonPagination(data, previousParams, nextParams);
  }

  Future<MastodonPagination<List<Account>>> getMutedAccounts({
    String? maxId,
    String? sinceId,
    String? minId,
  }) async {
    final response = await client.sendRequest(
      HttpMethod.get,
      "api/v1/mutes",
      query: {
        if (maxId != null) "max_id": maxId,
        if (sinceId != null) "since_id": sinceId,
        if (minId != null) "min_id": minId,
      },
    );
    final accounts = Account.fromJson.fromResponseList(response);
    final linkHeader = response.headers["link"];
    return _createPagination(accounts, linkHeader);
  }

  Future<void> muteAccount(String id) async =>
      client.sendRequest(HttpMethod.post, "api/v1/accounts/$id/mute");

  Future<void> unmuteAccount(String id) async =>
      client.sendRequest(HttpMethod.post, "api/v1/accounts/$id/unmute");

  Future<MarkerResponse> setMarkerPosition({String? notifications}) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/v1/markers",
          body: {
            if (notifications != null)
              "notifications": {"last_read_id": notifications},
          }.jsonBody,
        )
        .then(MarkerResponse.fromJson.fromResponse);
  }

  Future<Account> lookupAccount(String acct) async {
    return client.sendRequest(
      HttpMethod.get,
      "api/v1/accounts/lookup",
      query: {"acct": acct},
    ).then(Account.fromJson.fromResponse);
  }

  Future<Relationship> getRelationship(String id) async {
    return client
        .sendRequest(
          HttpMethod.get,
          "api/v1/accounts/relationships",
          query: {"id": id},
        )
        .then(Relationship.fromJson.fromResponseList)
        .then((list) => list.firstWhere((e) => e.id == id));
  }

  Future<Relationship> followAccount(String id) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/v1/accounts/$id/follow",
        )
        .then(Relationship.fromJson.fromResponse);
  }

  Future<Relationship> unfollowAccount(String id) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/v1/accounts/$id/unfollow",
        )
        .then(Relationship.fromJson.fromResponse);
  }
}
