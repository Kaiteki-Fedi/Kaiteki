import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:kaiteki/auth/login_typedefs.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/backends/twitter/v2/capabilities.dart';
import 'package:kaiteki/fediverse/backends/twitter/v2/client.dart';
import 'package:kaiteki/fediverse/backends/twitter/v2/extensions.dart';
import 'package:kaiteki/fediverse/backends/twitter/v2/model/media.dart';
import 'package:kaiteki/fediverse/backends/twitter/v2/model/tweet.dart';
import 'package:kaiteki/fediverse/backends/twitter/v2/model/user.dart'
    show UserField;
import 'package:kaiteki/fediverse/capabilities.dart';
import 'package:kaiteki/fediverse/interfaces/bookmark_support.dart';
import 'package:kaiteki/fediverse/interfaces/favorite_support.dart';
import 'package:kaiteki/fediverse/interfaces/search_support.dart';
import 'package:kaiteki/fediverse/model/attachment.dart';
import 'package:kaiteki/fediverse/model/instance.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/post_draft.dart';
import 'package:kaiteki/fediverse/model/timeline_kind.dart';
import 'package:kaiteki/fediverse/model/timeline_query.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/model/auth/account.dart';
import 'package:kaiteki/model/auth/account_key.dart';
import 'package:kaiteki/model/auth/login_result.dart';
import 'package:kaiteki/model/auth/secret.dart';
import 'package:kaiteki/model/file.dart';
import 'package:kaiteki/utils/extensions.dart';

const clientId = kDebugMode
    ? "QTFFSnY5d2QwTkp3enliMHdfaXg6MTpjaQ"
    : "Q2lkU2p0VERwOWxreXdxeFVsQm46MTpjaQ";

class TwitterAdapter extends CentralizedBackendAdapter
    implements FavoriteSupport, BookmarkSupport, SearchSupport {
  final TwitterClient client;

  factory TwitterAdapter() {
    return TwitterAdapter.custom(TwitterClient());
  }

  TwitterAdapter.custom(this.client);

  @override
  AdapterCapabilities get capabilities => const TwitterCapabilities();

  @override
  Future<User?> followUser(String id) {
    // TODO(Craftplacer): implement followUser
    throw UnimplementedError();
  }

  @override
  Future<User> getMyself() async {
    final user = await client.getMe(userFields: UserField.values.toSet());
    return user.toKaiteki();
  }

  @override
  Future<Post> getPostById(String id) async {
    final response = await client.getTweet(
      id,
      expansions: {
        "author_id",
        "referenced_tweets.id",
        "referenced_tweets.id.author_id",
        "attachments.media_keys",
        "in_reply_to_user_id",
      },
      tweetFields: TweetField.values.toSet(),
      userFields: UserField.values.toSet(),
      mediaFields: MediaField.values.toSet(),
    );
    return response.data.toKaiteki(response.includes!);
  }

  @override
  Future<List<User>> getRepeatees(String id) {
    // TODO(Craftplacer): implement getRepeatees
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Post>> getStatusesOfUserById(
    String id, {
    TimelineQuery<String>? query,
  }) async {
    final response = await client.getUserTweets(
      id,
      expansions: {
        "author_id",
        "referenced_tweets.id",
        "referenced_tweets.id.author_id",
        "attachments.media_keys",
        "in_reply_to_user_id",
      },
      tweetFields: TweetField.values.toSet(),
      userFields: UserField.values.toSet(),
      mediaFields: MediaField.values.toSet(),
    );

    return response.data.map((t) => t.toKaiteki(response.includes!));
  }

  @override
  Future<Iterable<Post>> getThread(Post reply) async {
    final conversationId = (reply.source as Tweet).conversationId;

    if (conversationId == null) {
      throw ArgumentError("Tweet's conversation ID was null");
    }

    final response = await client.searchRecentTweets(
      "conversation_id:$conversationId",
      expansions: {
        "author_id",
        "referenced_tweets.id",
        "referenced_tweets.id.author_id",
        "attachments.media_keys",
        "in_reply_to_user_id",
      },
      tweetFields: TweetField.values.toSet(),
      userFields: UserField.values.toSet(),
      mediaFields: MediaField.values.toSet(),
    );

    final tweets = [
      if (response.data != null) ...response.data!,
      if (response.includes?.tweets != null) ...response.includes!.tweets!,
    ].distinct((a, b) => a.id == b.id);

    if (tweets.isEmpty) return [reply];

    final hasReply = tweets.any((t) => t.id == reply.id);
    final posts = [
      if (!hasReply) reply,
      ...tweets //
          .map((t) => t.toKaiteki(response.includes!))
          .toList()
          .reversed,
    ]..sort((a, b) => a.postedAt.compareTo(b.postedAt));

    return posts;
  }

  @override
  Future<Iterable<Post>> getTimeline(
    TimelineKind type, {
    TimelineQuery<String>? query,
  }) async {
    if (type != TimelineKind.home) {
      throw UnsupportedError("Twitter doesn't support $type");
    }
    final response = await client.getReverseChronologicalTimeline(
      expansions: {
        "author_id",
        "referenced_tweets.id",
        "referenced_tweets.id.author_id",
        "attachments.media_keys",
        "in_reply_to_user_id",
      },
      tweetFields: TweetField.values.toSet(),
      userFields: UserField.values.toSet(),
      mediaFields: MediaField.values.toSet(),
      sinceId: query?.sinceId,
      untilId: query?.untilId,
    );

    return response.data.map((t) => t.toKaiteki(response.includes!)).toList();
  }

  @override
  Future<User> getUser(String username, [String? instance]) {
    // TODO(Craftplacer): implement getUser
    throw UnimplementedError();
  }

  @override
  Future<User> getUserById(String id) async {
    final user = await client.getUser(
      id,
      expansions: {"pinned_tweet_id"},
      tweetFields: {TweetField.createdAt},
      userFields: UserField.values.toSet(),
    );
    return user.data.toKaiteki();
  }

  @override
  Future<LoginResult> login(
    ClientSecret? clientSecret,
    CredentialsCallback requestCredentials,
    MfaCallback requestMfa,
    OAuthCallback requestOAuth,
  ) async {
    late Uri redirectUri;
    final oauthResponse = await requestOAuth(
      (callbackUrl) {
        const scope = [
          "tweet.read",
          "tweet.write",
          "tweet.moderate.write",
          "users.read",
          "follows.read",
          "follows.write",
          "offline.access",
          "mute.read",
          "mute.write",
          "like.read",
          "like.write",
          "list.read",
          "list.write",
          "block.read",
          "block.write",
          "bookmark.read",
          "bookmark.write",
        ];
        final authorizationUrl = Uri.https(
          "twitter.com",
          "i/oauth2/authorize",
          {
            "response_type": "code",
            "client_id": clientId,
            "redirect_uri": (redirectUri = callbackUrl).toString(),
            "scope": scope.join(" "),
            "state": "state",
            "code_challenge": "challenge",
            "code_challenge_method": "plain",
          },
        );

        return Future.value(authorizationUrl);
      },
    );

    if (oauthResponse == null) return const LoginResult.aborted();

    final oauthCode = oauthResponse["code"]!;

    final token = await client.getToken(
      code: oauthCode,
      clientId: clientId,
      grantType: "authorization_code",
      redirectUri: redirectUri.toString(),
      codeVerifier: "challenge",
    );

    client.token = token.accessToken;
    final me = await client.getMe(userFields: UserField.values.toSet());
    client.userId = me.id;

    return LoginResult.successful(
      Account(
        accountSecret: AccountSecret(
          token.accessToken,
          token.refreshToken,
          me.id,
        ),
        adapter: this,
        user: me.toKaiteki(),
        clientSecret: null,
        key: AccountKey(
          ApiType.twitter,
          "twitter.com",
          me.username,
        ),
      ),
    );
  }

  @override
  Future<Post> postStatus(PostDraft draft, {Post? parentPost}) async {
    final tweet = await client.createTweet(
      text: draft.content,
      inReplyToTweetId: draft.replyTo?.id,
    );

    final response = await client.getTweet(
      tweet.id,
      expansions: {
        "author_id",
        "referenced_tweets.id",
        "referenced_tweets.id.author_id",
        "attachments.media_keys",
        "in_reply_to_user_id",
      },
      tweetFields: {TweetField.createdAt},
      userFields: UserField.values.toSet(),
      mediaFields: {
        MediaField.altText,
        MediaField.url,
        MediaField.previewImageUrl,
      },
    );
    return response.data.toKaiteki(response.includes!);
  }

  @override
  Future<Post?> repeatPost(String id) {
    // TODO(Craftplacer): implement repeatPost
    throw UnimplementedError();
  }

  @override
  Future<Post?> unrepeatPost(String id) {
    // TODO(Craftplacer): implement unrepeatPost
    throw UnimplementedError();
  }

  @override
  Future<Attachment> uploadAttachment(File file, String? description) {
    // TODO(Craftplacer): implement uploadAttachment
    throw UnimplementedError();
  }

  @override
  Future<void> favoritePost(String id) async {
    final response = await client.likeTweet(id);
    assert(response.data.liked);
  }

  @override
  Future<List<User>> getFavoritees(String id) async {
    final response = await client.getLikingUsers(id);
    return response.data.map((u) => u.toKaiteki()).toList();
  }

  @override
  Future<void> unfavoritePost(String id) async {
    final response = await client.unlikeTweet(id);
    assert(!response.data.liked);
  }

  @override
  Future<void> bookmarkPost(String id) async {
    final response = await client.bookmarkTweet(id);
    assert(response.data.bookmarked);
  }

  @override
  Future<List<Post>> getBookmarks({
    String? maxId,
    String? sinceId,
    String? minId,
  }) async {
    final response = await client.getBookmarks(
      expansions: {
        "author_id",
        "referenced_tweets.id",
        "referenced_tweets.id.author_id",
        "attachments.media_keys",
        "in_reply_to_user_id",
      },
      tweetFields: {TweetField.createdAt},
      userFields: UserField.values.toSet(),
      mediaFields: {
        MediaField.altText,
        MediaField.url,
        MediaField.previewImageUrl,
      },
    );
    return response.data
            ?.map((t) => t.toKaiteki(response.includes!))
            .toList() ??
        [];
  }

  @override
  Future<void> unbookmarkPost(String id) async {
    final response = await client.bookmarkTweet(id);
    assert(!response.data.bookmarked);
  }

  @override
  Future<void> applySecrets(
    ClientSecret? clientSecret,
    AccountSecret accountSecret,
  ) async {
    if (accountSecret.refreshToken != null) {
      final token = await client.getToken(
        clientId: clientId,
        grantType: "refresh_token",
        refreshToken: accountSecret.refreshToken,
      );

      client.token = token.accessToken;
      final me = await client.getMe(userFields: UserField.values.toSet());
      client.userId = me.id;

      return;
    }

    client
      ..userId = accountSecret.userId
      ..token = accountSecret.accessToken;
  }

  @override
  final instance = const Instance(
    name: "Twitter",
    backgroundUrl:
        "https://abs.twimg.com/sticky/illustrations/lohp_en_1302x955.png",
  );

  @override
  Future<SearchResults> search(String query) async {
    return SearchResults(
      posts: await searchForPosts(query),
    );
  }

  @override
  Future<List<String>> searchForHashtags(String query) {
    // TODO: implement searchForHashtags
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> searchForPosts(String query) async {
    final response = await client.searchRecentTweets(query);
    return response.data!.map((t) => t.toKaiteki(response.includes!)).toList();
  }

  @override
  Future<List<User>> searchForUsers(String query) {
    // TODO: implement searchForUsers
    throw UnimplementedError();
  }
}
