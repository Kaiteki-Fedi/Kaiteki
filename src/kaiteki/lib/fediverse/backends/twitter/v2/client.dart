// ignore_for_file: unnecessary_await_in_return, obfuscates method call

import 'dart:async';

import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/backends/twitter/v2/adapter.dart'
    show clientId;
import 'package:kaiteki/fediverse/backends/twitter/v2/authentication_data.dart';
import 'package:kaiteki/fediverse/backends/twitter/v2/model/tweet.dart';
import 'package:kaiteki/fediverse/backends/twitter/v2/model/user.dart';
import 'package:kaiteki/fediverse/backends/twitter/v2/responses/bookmark_response.dart';
import 'package:kaiteki/fediverse/backends/twitter/v2/responses/like_response.dart';
import 'package:kaiteki/fediverse/backends/twitter/v2/responses/response.dart';
import 'package:kaiteki/fediverse/backends/twitter/v2/responses/timeline_response.dart';
import 'package:kaiteki/fediverse/backends/twitter/v2/responses/token_response.dart';
import 'package:kaiteki/fediverse/backends/twitter/v2/responses/user_response.dart';
import 'package:kaiteki/fediverse/client_base.dart';
import 'package:kaiteki/http/response.dart' as ktk;
import 'package:kaiteki/logger.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/http_method.dart';
import 'package:kaiteki/utils/extensions.dart';

import 'model/media.dart';

class TwitterClient extends FediverseClientBase<TwitterAuthenticationData> {
  static final _logger = getLogger("TwitterClient");

  TwitterClient() : super("twitter.com");

  @override
  String get baseUrl => "https://api.twitter.com";

  @override
  FutureOr<void> setAccountAuthentication(AccountSecret secret) async {
    if (secret.refreshToken == null) {
      authenticationData = TwitterAuthenticationData(
        secret.accessToken,
        secret.userId,
      );
    } else {
      _logger.v("Refreshing account token");

      final token = await getToken(
        clientId: clientId,
        grantType: "refresh_token",
        refreshToken: secret.refreshToken,
      );

      authenticationData = TwitterAuthenticationData(
        token.accessToken,
        null,
      );

      final me = await getMe(userFields: UserField.values.toSet());

      authenticationData = TwitterAuthenticationData(
        token.accessToken,
        me.id,
      );
    }
  }

  @override
  ApiType get type => ApiType.twitter;

  Future<User> getMe({
    UserFields userFields = const {},
  }) async {
    final query = {
      if (userFields.isNotEmpty) "user.fields": userFields.join(","),
    };
    return await sendJsonRequest(
      HttpMethod.get,
      "2/users/me${query.toQueryString()}",
      (j) => User.fromJson(j["data"]!),
    );
  }

  Future<TweetResponse> getTweet(
    String id, {
    Set<String> expansions = const {},
    TweetFields tweetFields = const {},
    UserFields userFields = const {},
    MediaFields mediaFields = const {},
  }) async {
    final query = {
      if (expansions.isNotEmpty) "expansions": expansions.join(","),
      if (tweetFields.isNotEmpty) "tweet.fields": tweetFields.join(","),
      if (userFields.isNotEmpty) "user.fields": userFields.join(","),
      if (mediaFields.isNotEmpty) "media.fields": mediaFields.join(","),
    };

    return await sendJsonRequest(
      HttpMethod.get,
      "2/tweets/$id${query.toQueryString()}",
      (j) => TweetResponse.fromJson(j, Tweet.fromJson.generic),
    );
  }

  Future<Tweet> createTweet({
    String? text,
    String? inReplyToTweetId,
    Set<String> excludeReplyUserIds = const {},
    String? quoteTweetId,
    TweetReplySettings replySettings = TweetReplySettings.everyone,
  }) async {
    final id = authenticationData!.userId!;
    return await sendJsonRequest(
      HttpMethod.post,
      "2/tweets",
      (json) => Tweet.fromJson(json["data"]),
      body: {
        if (text != null) "text": text,
        if (replySettings != TweetReplySettings.everyone)
          "reply_settings": replySettings.name,
        if (inReplyToTweetId != null)
          "reply": {
            "in_reply_to_tweet_id": inReplyToTweetId,
            "exclude_reply_user_ids": excludeReplyUserIds.toList(
              growable: false,
            ),
          },
        if (quoteTweetId != null) "quote_tweet_id": quoteTweetId,
        "direct_message_deep_link":
            "https://twitter.com/messages/compose?recipient_id=$id"
      },
    );
  }

  Future<TimelineResponse> getReverseChronologicalTimeline({
    Set<String> expansions = const {},
    TweetFields tweetFields = const {},
    UserFields userFields = const {},
    MediaFields mediaFields = const {},
    String? untilId,
    String? sinceId,
  }) async {
    final query = {
      if (expansions.isNotEmpty) "expansions": expansions.join(","),
      if (tweetFields.isNotEmpty) "tweet.fields": tweetFields.join(","),
      if (userFields.isNotEmpty) "user.fields": userFields.join(","),
      if (mediaFields.isNotEmpty) "media.fields": mediaFields.join(","),
      if (untilId != null) "until_id": untilId,
      if (sinceId != null) "since_id": sinceId,
    };

    final id = authenticationData!.userId!;
    return await sendJsonRequest(
      HttpMethod.get,
      "2/users/$id/timelines/reverse_chronological${query.toQueryString()}",
      TimelineResponse.fromJson,
    );
  }

  Future<TimelineResponse> getUserTweets(
    String id, {
    Set<String> expansions = const {},
    TweetFields tweetFields = const {},
    UserFields userFields = const {},
    MediaFields mediaFields = const {},
    String? untilId,
    String? sinceId,
  }) async {
    final query = {
      if (expansions.isNotEmpty) "expansions": expansions.join(","),
      if (tweetFields.isNotEmpty) "tweet.fields": tweetFields.join(","),
      if (userFields.isNotEmpty) "user.fields": userFields.join(","),
      if (mediaFields.isNotEmpty) "media.fields": mediaFields.join(","),
      if (untilId != null) "until_id": untilId,
      if (sinceId != null) "since_id": sinceId,
    };

    return await sendJsonRequest(
      HttpMethod.get,
      "2/users/$id/tweets${query.toQueryString()}",
      TimelineResponse.fromJson,
    );
  }

  Future<UserResponse> getUser(
    String id, {
    Set<String> expansions = const {},
    TweetFields tweetFields = const {},
    UserFields userFields = const {},
  }) async {
    final query = {
      if (expansions.isNotEmpty) "expansions": expansions.join(","),
      if (tweetFields.isNotEmpty) "tweet.fields": tweetFields.join(","),
      if (userFields.isNotEmpty) "user.fields": userFields.join(","),
    };

    return await sendJsonRequest(
      HttpMethod.get,
      "2/users/$id${query.toQueryString()}",
      UserResponse.fromJson,
    );
  }

  @override
  Future<void> checkResponse(ktk.Response response) async {
    if (!response.isSuccessful) {
      Map<String, dynamic>? json;

      try {
        json = await response.getContentJson();
      } catch (_) {}

      if (json != null) throw Exception(json["title"] ?? json["detail"]);
    }

    super.checkResponse(response);
  }

  Future<TweetListResponse> searchRecentTweets(
    String query, {
    Set<String> expansions = const {},
    TweetFields tweetFields = const {},
    UserFields userFields = const {},
    MediaFields mediaFields = const {},
  }) async {
    final urlQuery = {
      "query": query,
      if (expansions.isNotEmpty) "expansions": expansions.join(","),
      if (tweetFields.isNotEmpty) "tweet.fields": tweetFields.join(","),
      if (userFields.isNotEmpty) "user.fields": userFields.join(","),
      if (mediaFields.isNotEmpty) "media.fields": mediaFields.join(","),
    };

    return await sendJsonRequest(
      HttpMethod.get,
      "2/tweets/search/recent${urlQuery.toQueryString()}",
      (j) => TweetListResponse.fromJson(j, Tweet.fromJson.genericList),
    );
  }

  Future<TokenResponse> getToken({
    required String clientId,
    required String grantType,
    String? code,
    String? redirectUri,
    String? codeVerifier,
    String? refreshToken,
  }) async {
    final map = <String, String>{
      "grant_type": grantType,
      "client_id": clientId,
      if (codeVerifier != null) "code_verifier": codeVerifier,
      if (redirectUri != null) "redirect_uri": redirectUri,
      if (code != null) "code": code,
      if (refreshToken != null) "refresh_token": refreshToken,
    };

    final response = await sendRequest(
      HttpMethod.post,
      "2/oauth2/token",
      contentType: "application/x-www-form-urlencoded",
      body: Uri(queryParameters: map).query,
    );

    final json = await response.getContentJson();
    return TokenResponse.fromJson(json);
  }

  Future<BookmarkResponse> bookmarkTweet(String tweetId) async {
    final id = authenticationData!.userId!;
    return await sendJsonRequest(
      HttpMethod.post,
      "2/users/$id/bookmarks",
      (j) => BookmarkResponse.fromJson(
        j,
        BookmarkResponseData.fromJson.generic,
      ),
      body: {"tweet_id": tweetId},
    );
  }

  Future<BookmarkResponse> unbookmarkTweet(String tweetId) async {
    final id = authenticationData!.userId!;
    return await sendJsonRequest(
      HttpMethod.delete,
      "2/users/$id/bookmarks/$tweetId",
      (j) => BookmarkResponse.fromJson(
        j,
        BookmarkResponseData.fromJson.generic,
      ),
    );
  }

  Future<TweetListResponse> getBookmarks({
    Set<String> expansions = const {},
    TweetFields tweetFields = const {},
    UserFields userFields = const {},
    MediaFields mediaFields = const {},
  }) async {
    final urlQuery = {
      if (expansions.isNotEmpty) "expansions": expansions.join(","),
      if (tweetFields.isNotEmpty) "tweet.fields": tweetFields.join(","),
      if (userFields.isNotEmpty) "user.fields": userFields.join(","),
      if (mediaFields.isNotEmpty) "media.fields": mediaFields.join(","),
    };

    final id = authenticationData!.userId!;
    return await sendJsonRequest(
      HttpMethod.get,
      "2/users/$id/bookmarks${urlQuery.toQueryString()}",
      (j) => TweetListResponse.fromJson(j, Tweet.fromJson.genericList),
    );
  }

  Future<LikeResponse> likeTweet(String tweetId) async {
    final id = authenticationData!.userId!;
    return await sendJsonRequest(
      HttpMethod.post,
      "2/users/$id/likes",
      (j) => LikeResponse.fromJson(j, LikeResponseData.fromJson.generic),
      body: {"tweet_id": tweetId},
    );
  }

  Future<LikeResponse> unlikeTweet(String tweetId) async {
    final id = authenticationData!.userId!;
    return await sendJsonRequest(
      HttpMethod.delete,
      "2/users/$id/likes/$tweetId",
      (j) => LikeResponse.fromJson(j, LikeResponseData.fromJson.generic),
    );
  }

  Future<LikingUsersResponse> getLikingUsers(
    String id, {
    TweetFields tweetFields = const {},
    UserFields userFields = const {},
  }) async {
    final id = authenticationData!.userId!;
    return await sendJsonRequest(
      HttpMethod.delete,
      "2/users/$id/likes",
      (j) => LikingUsersResponse.fromJson(
        j,
        (obj) => User.fromJson.genericList(obj)!,
      ),
    );
  }
}
