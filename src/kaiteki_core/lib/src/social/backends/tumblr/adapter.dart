import 'dart:async';
import 'dart:convert';

import 'package:kaiteki_core/social.dart';
import 'package:uuid/uuid.dart';

import 'capabilities.dart';
import 'client.dart';
import 'extensions.dart';

const scopes = ['basic', 'write', 'offline_access'];
const consumerKey = 'FZlWlVPgJDmHF0fLssyJpoLqDmaxaGjcVlDW618dFVG61MvogO';
const consumerSecret = '6RTwNsXOfEZIc0avog23jAU6lMXhfVN7z11TQq0P3YRsOU5NSN';

class TumblrAdapter extends CentralizedBackendAdapter
    implements NotificationSupport, SearchSupport, LoginSupport {
  final TumblrClient client;

  factory TumblrAdapter() {
    return TumblrAdapter.custom(TumblrClient());
  }

  TumblrAdapter.custom(this.client);

  @override
  FutureOr<void> applySecrets(
    ClientSecret? clientSecret,
    UserSecret userSecret,
  ) {
    super.applySecrets(clientSecret, userSecret);
    client.accessToken = userSecret.accessToken;
  }

  @override
  AdapterCapabilities get capabilities => const TumblrCapabilities();

  @override
  Future<void> deleteAccount(String password) {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Future<User?> followUser(String id) {
    // TODO: implement followUser
    throw UnimplementedError();
  }

  @override
  Future<PaginatedList<String?, User>> getFollowers(
    String userId, {
    String? sinceId,
    String? untilId,
  }) {
    // TODO: implement getFollowers
    throw UnimplementedError();
  }

  @override
  Future<PaginatedList<String?, User>> getFollowing(
    String userId, {
    String? sinceId,
    String? untilId,
  }) {
    // TODO: implement getFollowing
    throw UnimplementedError();
  }

  @override
  Future<User> getMyself() async {
    final response = await client.getUserInfo();
    return response.user.toKaiteki();
  }

  @override
  Future<Post> getPostById(String id) {
    // TODO: implement getPostById
    throw UnimplementedError();
  }

  @override
  Future<List<User>> getRepeatees(String id) {
    // TODO: implement getRepeatees
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getStatusesOfUserById(
    String id, {
    TimelineQuery<String>? query,
  }) async {
    final response = await client.getBlogPosts(id);
    return response.posts.map((e) => e.toKaiteki()).toList();
  }

  @override
  Future<Iterable<Post>> getThread(Post reply) {
    // TODO: implement getThread
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getTimeline(
    TimelineType type, {
    TimelineQuery<String>? query,
  }) async {
    final blogFields = [
      'name',
      'avatar',
      'title',
      'url',
      'uuid',
      '?followed',
      'theme',
      '?primary',
      '?paywall_access',
      'tumblrmart_accessories',
      'can_show_badges',
      '?live_now',
    ];

    switch (type) {
      case TimelineType.following:
        final response = await client.getDashboard(
          sinceId: query?.untilId,
          reblogInfo: true,
          notesInfo: true,
          npf: false,
          fields: {'blogs': blogFields},
        );

        return response.posts
            .map((e) => e.toKaiteki())
            .toList()
            .reversed
            .toList();

      default:
        throw UnsupportedError('Timeline type $type is not supported');
    }
  }

  @override
  Future<User> getUser(String username, [String? instance]) {
    return getUserById(username);
  }

  @override
  Future<User> getUserById(String id) async {
    final response = await client.getBlogInfo(id);
    return response.blog.toKaiteki();
  }

  @override
  final instance = const Instance(
    name: 'Tumblr',
  );

  @override
  Future<LoginResult> login(LoginContext context) async {
    final state = const Uuid().v4();

    const redirectUri = 'https://kaiteki.app/oauth';
    await context.openUrl(
      Uri.https(
        'tumblr.com',
        '/oauth2/authorize',
        {
          'response_type': 'code',
          'client_id': consumerKey,
          'redirect_uri': redirectUri,
          'scope': scopes.join(' '),
          'state': state,
        },
      ),
    );

    late final String code;

    await context.requestCode(
      const CodePromptOptions(),
      (input) async {
        final bytes = base64.decode(input);
        final json = utf8.decode(bytes);
        final params = jsonDecode(json) as Map<String, dynamic>;
        if (state != params['state']) throw Exception('Invalid state');
        code = params['code']! as String;
      },
    );

    final tokenResponse = await client.getToken(
      clientId: consumerKey,
      clientSecret: consumerSecret,
      code: code,
      redirectUri: redirectUri,
    );

    client.accessToken = tokenResponse.accessToken;

    final userInfoResponse = await client.getUserInfo();

    return LoginSuccess(
      user: userInfoResponse.user.toKaiteki(),
      userSecret: (
        accessToken: tokenResponse.accessToken,
        refreshToken: tokenResponse.refreshToken,
        userId: userInfoResponse.user.name,
      ),
      clientSecret: null,
    );
  }

  @override
  Future<User> lookupUser(String username, [String? host]) {
    // TODO: implement lookupUser
    throw UnimplementedError();
  }

  @override
  Future<Post> postStatus(PostDraft draft, {Post? parentPost}) {
    // TODO: implement postStatus
    throw UnimplementedError();
  }

  @override
  Future<void> repeatPost(String id) {
    // TODO: implement repeatPost
    throw UnimplementedError();
  }

  @override
  Future<void> unrepeatPost(String id) {
    // TODO: implement unrepeatPost
    throw UnimplementedError();
  }

  @override
  Future<Attachment> uploadAttachment(AttachmentDraft draft) {
    // TODO: implement uploadAttachment
    throw UnimplementedError();
  }

  @override
  Future<void> clearAllNotifications() {
    // TODO: implement clearAllNotifications
    throw UnimplementedError();
  }

  @override
  Future<List<Notification>> getNotifications() {
    // TODO: implement getNotifications
    throw UnimplementedError();
  }

  @override
  Future<void> markAllNotificationsAsRead() {
    // TODO: implement markAllNotificationsAsRead
    throw UnimplementedError();
  }

  @override
  Future<void> markNotificationAsRead(Notification notification) {
    // TODO: implement markNotificationAsRead
    throw UnimplementedError();
  }

  @override
  Future<SearchResults> search(String query) async {
    final response = await client.search(query);
    return SearchResults(
      posts: response.posts.map((e) => e.toKaiteki()).toList(),
    );
  }

  @override
  Future<List<String>> searchForHashtags(String query) {
    // TODO: implement searchForHashtags
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> searchForPosts(String query) {
    // TODO: implement searchForPosts
    throw UnimplementedError();
  }

  @override
  Future<List<User>> searchForUsers(String query) {
    // TODO: implement searchForUsers
    throw UnimplementedError();
  }

  @override
  Future<Object?> resolveUrl(Uri url) {
    // TODO: implement resolveUrl
    throw UnimplementedError();
  }

  @override
  ApiType<TumblrAdapter> get type => ApiType.tumblr;

  @override
  Future<User?> unfollowUser(String id) {
    // TODO: implement unfollowUser
    throw UnimplementedError();
  }
}
