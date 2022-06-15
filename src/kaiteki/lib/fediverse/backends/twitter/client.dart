import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/backends/twitter/auth/oauth_token.dart';
import 'package:kaiteki/fediverse/backends/twitter/model/tweet.dart';
import 'package:kaiteki/fediverse/backends/twitter/model/user.dart';
import 'package:kaiteki/fediverse/client_base.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/model/http_method.dart';
import 'package:kaiteki/utils/utils.dart';

class TwitterClient extends FediverseClientBase {
  @override
  String get baseUrl => "https://api.twitter.com";

  @override
  Future<void> setAccountAuthentication(AccountSecret secret) async {
    // TODO: implement setAccountAuthentication
    // throw UnimplementedError();
  }

  @override
  Future<void> setClientAuthentication(ClientSecret secret) async {
    // TODO: implement setClientAuthentication
    // throw UnimplementedError();
    // authenticationData = TwitterAuthenticationData();
  }

  Future<Iterable<Tweet>> getHomeTimeline({
    String? sinceId,
    String? maxId,
  }) async {
    return sendJsonRequestMultiple(
      HttpMethod.get,
      withQueries(
        "1.1/statuses/home_timeline.json",
        {
          if (sinceId != null) "since_id": sinceId,
          if (maxId != null) "max_id": maxId,
        },
      ),
      Tweet.fromJson,
    );
  }

  Future<Tweet> updateStatus(String status) async {
    return sendJsonRequest(
      HttpMethod.post,
      "1.1/statuses/update.json?status=${Uri.encodeQueryComponent(status)}",
      Tweet.fromJson,
      body: {},
    );
  }

  Future<User> verifyCredentials() async {
    return sendJsonRequest(
      HttpMethod.get,
      "1.1/account/verify_credentials.json",
      User.fromJson,
    );
  }

  Future<OAuthToken> requestToken(
    String consumerKey,
    String consumerSecret,
  ) async {
    final response = await sendRequest(
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
    final text = await response.getContentText();
    for (final pair in text.split("&")) {
      final kv = pair.split("=");
      map[kv[0]] = kv[1];
    }

    return OAuthToken(
      map["oauth_token"]!,
      map["oauth_token_secret"]!,
      map["oauth_callback_confirmed"] == "true",
    );
  }

  @override
  ApiType get type => ApiType.twitter;

  Future<Iterable<Tweet>> getUserTimeline({
    String? sinceId,
    String? maxId,
    int? count,
    String? userId,
    String? screenName,
  }) async {
    return sendJsonRequestMultiple(
      HttpMethod.get,
      withQueries(
        "1.1/statuses/user_timeline.json",
        {
          if (sinceId != null) "since_id": sinceId,
          if (maxId != null) "max_id": maxId,
          if (count != null) "count": count,
          if (userId != null) "user_id": userId,
          if (screenName != null) "screen_name": screenName,
        },
      ),
      Tweet.fromJson,
    );
  }

  Future<User> getUser({String? userId, String? screenName}) async {
    return sendJsonRequest(
      HttpMethod.get,
      withQueries(
        "1.1/users/show.json",
        {
          if (userId != null) "user_id": userId,
          if (screenName != null) "screen_name": screenName,
        },
      ),
      User.fromJson,
    );
  }

  Future<Tweet> getTweet(
    String id, {
    bool? trimUser,
    bool? includeMyRetweet,
    bool? includeEntities,
    bool? includeExtAltText,
    bool? includeCardUri,
  }) async {
    return sendJsonRequest(
      HttpMethod.get,
      withQueries(
        "1.1/statuses/show.json",
        {
          "id": id,
          if (includeMyRetweet != null) "include_my_retweet": includeMyRetweet,
          if (includeEntities != null) "include_entities": includeEntities,
          if (includeExtAltText != null)
            "include_ext_alt_text": includeExtAltText,
          if (includeCardUri != null) "include_card_uri": includeCardUri,
        },
      ),
      Tweet.fromJson,
    );
  }
}
