import "package:kaiteki/fediverse/backends/twitter/v1/auth/oauth_token.dart";
import "package:kaiteki/fediverse/backends/twitter/v1/model/media_upload.dart";
import "package:kaiteki/fediverse/backends/twitter/v1/model/tweet.dart";
import "package:kaiteki/fediverse/backends/twitter/v1/model/user.dart";
import "package:kaiteki/http/http.dart";
import "package:kaiteki/model/file.dart";
import "package:oauth1/oauth1.dart"
    show ClientCredentials, Credentials, SignatureMethods;
// ignore: implementation_imports
import "package:oauth1/src/authorization_header_builder.dart";

class OldTwitterClient {
  late final KaitekiClient client;

  Credentials? credentials;
  ClientCredentials? clientCredentials;

  OldTwitterClient() {
    client = KaitekiClient(
      baseUri: Uri.parse("https://api.twitter.com"),
      intercept: (request) {
        if (credentials == null || clientCredentials == null) return;

        final ahb = AuthorizationHeaderBuilder()
          ..signatureMethod = SignatureMethods.hmacSha1
          ..clientCredentials = clientCredentials!
          ..credentials = credentials!
          ..method = request.method
          ..url = request.url.toString();

        request.headers["Authorization"] = ahb.build().toString();
      },
    );
  }

  Future<List<Tweet>> getHomeTimeline({
    String? sinceId,
    String? maxId,
  }) async {
    return client.sendRequest(
      HttpMethod.get,
      "1.1/statuses/home_timeline.json",
      query: {
        if (sinceId != null) "since_id": sinceId,
        if (maxId != null) "max_id": maxId,
      },
    ).then((r) => r.fromJsonList(Tweet.fromJson));
  }

  Future<Tweet> updateStatus(
    String status, {
    List<String> mediaIds = const [],
    String? replyToStatusId,
  }) async {
    return client.sendRequest(
      HttpMethod.post,
      "1.1/statuses/update.json",
      query: {
        "status": status,
        "media_ids": mediaIds.join(","),
        if (replyToStatusId != null) "in_reply_to_status_id": replyToStatusId,
      },
    ).then(Tweet.fromJson.fromResponse);
  }

  Future<User> verifyCredentials() async => client
      .sendRequest(HttpMethod.get, "1.1/account/verify_credentials.json")
      .then(User.fromJson.fromResponse);

  Future<OAuthToken> requestToken(
    String consumerKey,
    String consumerSecret,
  ) async {
    final response = await client.sendRequest(
      HttpMethod.post,
      "oauth/request_token?oauth_callback=oob&x_auth_access_type=write",
      intercept: (request) {
        // request.headers["Authorization"] = generateAuthorizationHeader(
        //   HttpMethod.post,
        //   request.url,
        //   {"oauth_consumer_key": consumerKey},
        //   consumerSecret,
        // );
        request.headers["Accept"] = "*/*";
      },
    );

    final map = <String, String>{};
    for (final pair in response.body.split("&")) {
      final kv = pair.split("=");
      map[kv[0]] = kv[1];
    }

    return OAuthToken(
      token: map["oauth_token"]!,
      tokenSecret: map["oauth_token_secret"]!,
      callbackConfirmed: map["oauth_callback_confirmed"] == "true",
    );
  }

  Future<List<Tweet>> getUserTimeline({
    String? sinceId,
    String? maxId,
    int? count,
    String? userId,
    String? screenName,
  }) async {
    return client.sendRequest(
      HttpMethod.get,
      "1.1/statuses/user_timeline.json",
      query: {
        if (sinceId != null) "since_id": sinceId,
        if (maxId != null) "max_id": maxId,
        if (count != null) "count": count,
        if (userId != null) "user_id": userId,
        if (screenName != null) "screen_name": screenName,
      },
    ).then(Tweet.fromJson.fromResponseList);
  }

  Future<User> getUser({String? userId, String? screenName}) async {
    return client.sendRequest(
      HttpMethod.get,
      "1.1/users/show.json",
      query: {
        if (userId != null) "user_id": userId,
        if (screenName != null) "screen_name": screenName,
      },
    ).then(User.fromJson.fromResponse);
  }

  Future<Tweet> getTweet(
    String id, {
    bool? trimUser,
    bool? includeMyRetweet,
    bool? includeEntities,
    bool? includeExtAltText,
    bool? includeCardUri,
  }) async {
    return client.sendRequest(
      HttpMethod.get,
      "1.1/statuses/show.json",
      query: {
        "id": id,
        if (includeMyRetweet != null) "include_my_retweet": includeMyRetweet,
        if (includeEntities != null) "include_entities": includeEntities,
        if (includeExtAltText != null)
          "include_ext_alt_text": includeExtAltText,
        if (includeCardUri != null) "include_card_uri": includeCardUri,
      },
    ).then(Tweet.fromJson.fromResponse);
  }

  Future<MediaUpload> uploadMedia(KaitekiFile file) async {
    return client.sendMultipartRequest(
      HttpMethod.post,
      "https://upload.twitter.com/1.1/media/upload.json",
      // FIXME(Craftplacer): this doesn't make sense
      query: {"media_category": "tweet_image"},
      fields: {"media_category": "tweet_image"},
      files: [await file.toMultipartFile("media")],
    ).then(MediaUpload.fromJson.fromResponse);
  }
}
