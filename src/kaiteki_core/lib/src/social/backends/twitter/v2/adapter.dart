import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:kaiteki_core/kaiteki_core.dart';

import 'capabilities.dart';
import 'client.dart';
import 'extensions.dart';
import 'model/media.dart';
import 'model/tweet.dart';
import 'model/user.dart' show UserField;

const clientId = 'Q2lkU2p0VERwOWxreXdxeFVsQm46MTpjaQ';
const scope = [
  'tweet.read',
  'tweet.write',
  'tweet.moderate.write',
  'users.read',
  'follows.read',
  'follows.write',
  'offline.access',
  'mute.read',
  'mute.write',
  'like.read',
  'like.write',
  'list.read',
  'list.write',
  'block.read',
  'block.write',
  'bookmark.read',
  'bookmark.write',
];

class TwitterAdapter extends CentralizedBackendAdapter
    implements FavoriteSupport, BookmarkSupport, SearchSupport, LoginSupport {
  final TwitterClient client;

  @override
  final instance = Instance(
    name: 'Twitter',
    backgroundUrl: Uri(
      scheme: 'https',
      host: 'abs.twimg.com',
      path: 'sticky/illustrations/lohp_en_1302x955.png',
    ),
  );

  factory TwitterAdapter() {
    return TwitterAdapter.custom(TwitterClient());
  }

  TwitterAdapter.custom(this.client);

  @override
  AdapterCapabilities get capabilities => const TwitterCapabilities();

  @override
  ApiType get type => ApiType.twitter;

  @override
  Future<void> applySecrets(
    ClientSecret? clientSecret,
    UserSecret userSecret,
  ) async {
    if (userSecret.refreshToken != null) {
      final token = await client.getToken(
        clientId: clientId,
        grantType: 'refresh_token',
        refreshToken: userSecret.refreshToken,
      );

      client.token = token.accessToken;
      final me = await client.getMe(userFields: UserField.values.toSet());
      client.userId = me.id;

      super.applySecrets(clientSecret, userSecret);
      return;
    }

    client
      ..userId = userSecret.userId
      ..token = userSecret.accessToken;

    super.applySecrets(clientSecret, userSecret);
  }

  @override
  Future<void> bookmarkPost(String id) async {
    final response = await client.bookmarkTweet(id);
    assert(response.data.bookmarked);
  }

  @override
  Future<void> deleteAccount(String password) => throw UnimplementedError();

  @override
  Future<void> favoritePost(String id) async {
    final response = await client.likeTweet(id);
    assert(response.data.liked);
  }

  @override
  Future<User?> followUser(String id) {
    // TODO(Craftplacer): implement followUser
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getBookmarks({
    String? maxId,
    String? sinceId,
    String? minId,
  }) async {
    final response = await client.getBookmarks(
      expansions: {
        'author_id',
        'referenced_tweets.id',
        'referenced_tweets.id.author_id',
        'attachments.media_keys',
        'in_reply_to_user_id',
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
  Future<List<User>> getFavoritees(String id) async {
    final response = await client.getLikingUsers(id);
    return response.data.map((u) => u.toKaiteki()).toList();
  }

  @override
  Future<PaginatedList<String?, User>> getFollowers(
    String userId, {
    String? sinceId,
    String? untilId,
  }) {
    // TODO(Craftplacer): implement getFollowers
    throw UnimplementedError();
  }

  @override
  Future<PaginatedList<String?, User>> getFollowing(
    String userId, {
    String? sinceId,
    String? untilId,
  }) {
    // TODO(Craftplacer): implement getFollowing
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
        'author_id',
        'referenced_tweets.id',
        'referenced_tweets.id.author_id',
        'attachments.media_keys',
        'in_reply_to_user_id',
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
  Future<List<Post>> getStatusesOfUserById(
    String id, {
    TimelineQuery<String>? query,
  }) async {
    final response = await client.getUserTweets(
      id,
      expansions: {
        'author_id',
        'referenced_tweets.id',
        'referenced_tweets.id.author_id',
        'attachments.media_keys',
        'in_reply_to_user_id',
      },
      tweetFields: TweetField.values.toSet(),
      userFields: UserField.values.toSet(),
      mediaFields: MediaField.values.toSet(),
    );

    return response.data.map((t) => t.toKaiteki(response.includes!)).toList();
  }

  @override
  Future<Iterable<Post>> getThread(Post reply) async {
    final conversationId = (reply.source as Tweet).conversationId;

    if (conversationId == null) {
      throw ArgumentError("Tweet's conversation ID was null");
    }

    final response = await client.searchRecentTweets(
      'conversation_id:$conversationId',
      expansions: {
        'author_id',
        'referenced_tweets.id',
        'referenced_tweets.id.author_id',
        'attachments.media_keys',
        'in_reply_to_user_id',
      },
      tweetFields: TweetField.values.toSet(),
      userFields: UserField.values.toSet(),
      mediaFields: MediaField.values.toSet(),
    );

    final tweets = [
      if (response.data != null) ...response.data!,
      if (response.includes?.tweets != null) ...response.includes!.tweets!,
    ].distinct(by: (a) => a.id);

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
  Future<List<Post>> getTimeline(
    TimelineKind type, {
    TimelineQuery<String>? query,
  }) async {
    if (type != TimelineKind.home) {
      throw UnsupportedError("Twitter doesn't support $type");
    }
    final response = await client.getReverseChronologicalTimeline(
      expansions: {
        'author_id',
        'referenced_tweets.id',
        'referenced_tweets.id.author_id',
        'attachments.media_keys',
        'in_reply_to_user_id',
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
      expansions: {'pinned_tweet_id'},
      tweetFields: {TweetField.createdAt},
      userFields: UserField.values.toSet(),
    );
    return user.data.toKaiteki();
  }

  @override
  Future<LoginResult> login(LoginContext context) async {
    late Uri redirectUri;

    final requestOAuth = context.requestOAuth;
    if (requestOAuth == null) {
      throw ArgumentError(
        'OAuth must be available for Twitter login',
        'context',
      );
    }

    final oauthResponse = await requestOAuth(
      (callbackUrl) {
        final authorizationUrl = Uri.https(
          'twitter.com',
          'i/oauth2/authorize',
          {
            'response_type': 'code',
            'client_id': clientId,
            'redirect_uri': (redirectUri = callbackUrl).toString(),
            'scope': scope.join(' '),
            'state': 'state',
            'code_challenge': 'challenge',
            'code_challenge_method': 'plain',
          },
        );

        return Future.value(authorizationUrl);
      },
    );
    if (oauthResponse == null) return const LoginAborted();

    final oauthCode = oauthResponse['code']!;

    final token = await client.getToken(
      code: oauthCode,
      clientId: clientId,
      grantType: 'authorization_code',
      redirectUri: redirectUri.toString(),
      codeVerifier: 'challenge',
    );

    client.token = token.accessToken;
    final me = await client.getMe(userFields: UserField.values.toSet());
    client.userId = me.id;

    return LoginSuccess(
      userSecret: (
        accessToken: token.accessToken,
        refreshToken: token.refreshToken,
        userId: me.id,
      ),
      user: me.toKaiteki(),
    );
  }

  @override
  Future<User> lookupUser(String username, [String? host]) =>
      throw UnimplementedError();

  @override
  Future<Post> postStatus(PostDraft draft, {Post? parentPost}) async {
    final tweet = await client.createTweet(
      text: draft.content,
      inReplyToTweetId: draft.replyTo?.id,
    );

    final response = await client.getTweet(
      tweet.id,
      expansions: {
        'author_id',
        'referenced_tweets.id',
        'referenced_tweets.id.author_id',
        'attachments.media_keys',
        'in_reply_to_user_id',
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
  Future<Post?> repeatPost(String id) async {
    final response = await client.retweet(id);
    assert(response.data.retweeted);
    return null;
  }

  @override
  Future<SearchResults> search(String query) async {
    return SearchResults(
      posts: await searchForPosts(query),
    );
  }

  @override
  Future<List<String>> searchForHashtags(String query) {
    // TODO(Craftplacer): implement searchForHashtags
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> searchForPosts(String query) async {
    final response = await client.searchRecentTweets(query);
    return response.data!.map((t) => t.toKaiteki(response.includes!)).toList();
  }

  @override
  Future<List<User>> searchForUsers(String query) {
    // TODO(Craftplacer): implement searchForUsers
    throw UnimplementedError();
  }

  @override
  Future<void> unbookmarkPost(String id) async {
    final response = await client.bookmarkTweet(id);
    assert(!response.data.bookmarked);
  }

  @override
  Future<void> unfavoritePost(String id) async {
    final response = await client.unlikeTweet(id);
    assert(!response.data.liked);
  }

  @override
  Future<User?> unfollowUser(String id) => throw UnimplementedError();

  @override
  Future<Post?> unrepeatPost(String id) async {
    final response = await client.undoRetweet(id);
    assert(!response.data.retweeted);
    return null;
  }

  @override
  Future<Attachment> uploadAttachment(AttachmentDraft draft) {
    // TODO(Craftplacer): implement uploadAttachment
    throw UnimplementedError();
  }

  @override
  Future<Object?> resolveUrl(Uri url) {
    // TODO: implement resolveUrl
    throw UnimplementedError();
  }
}
