import "dart:async";
import "dart:convert";

import "package:collection/collection.dart";
import "package:html/dom.dart";
import "package:html/parser.dart";
import "package:kaiteki/auth/login_typedefs.dart";
import "package:kaiteki/fediverse/adapter.dart";
import "package:kaiteki/fediverse/api_type.dart";
import "package:kaiteki/fediverse/backends/tumblr/capabilities.dart";
import "package:kaiteki/fediverse/backends/tumblr/client.dart";
import "package:kaiteki/fediverse/backends/tumblr/entities/blog.dart" as tumblr;
import "package:kaiteki/fediverse/backends/tumblr/entities/post.dart" as tumblr;
import "package:kaiteki/fediverse/backends/tumblr/entities/user_info.dart"
    as tumblr;
import "package:kaiteki/fediverse/capabilities.dart";
import "package:kaiteki/fediverse/interfaces/notification_support.dart";
import "package:kaiteki/fediverse/interfaces/search_support.dart";
import "package:kaiteki/fediverse/model/attachment.dart";
import "package:kaiteki/fediverse/model/instance.dart";
import "package:kaiteki/fediverse/model/notification.dart";
import "package:kaiteki/fediverse/model/pagination.dart";
import "package:kaiteki/fediverse/model/post/post.dart";
import "package:kaiteki/fediverse/model/timeline_kind.dart";
import "package:kaiteki/fediverse/model/timeline_query.dart";
import "package:kaiteki/fediverse/model/user/user.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/model/auth/login_result.dart";
import "package:kaiteki/model/auth/secret.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:url_launcher/url_launcher.dart";
import "package:uuid/uuid.dart";

const scopes = ["basic", "write", "offline_access"];
const consumerKey = "xxx";
const consumerSecret = "xxx";

class TumblrAdapter extends CentralizedBackendAdapter
    implements NotificationSupport, SearchSupport {
  final TumblrClient client;

  factory TumblrAdapter() {
    return TumblrAdapter.custom(TumblrClient());
  }

  TumblrAdapter.custom(this.client);

  @override
  FutureOr<void> applySecrets(
    ClientSecret? clientSecret,
    AccountSecret accountSecret,
  ) {
    client.accessToken = accountSecret.accessToken;
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
    TimelineKind type, {
    TimelineQuery<String>? query,
  }) async {
    final blogFields = [
      "name",
      "avatar",
      "title",
      "url",
      "uuid",
      "?followed",
      "theme",
      "?primary",
      "?paywall_access",
      "tumblrmart_accessories",
      "can_show_badges",
      "?live_now",
    ];

    switch (type) {
      case TimelineKind.home:
        final response = await client.getDashboard(
          sinceId: query?.sinceId,
          reblogInfo: true,
          notesInfo: true,
          npf: false,
          fields: {"blogs": blogFields},
        );

        return response.posts.map((e) => e.toKaiteki()).toList();

      default:
        throw UnsupportedError("Timeline type $type is not supported");
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
    name: "Tumblr",
  );

  @override
  Future<LoginResult> login(
    ClientSecret? clientSecret,
    CredentialsCallback requestCredentials,
    CodeCallback requestCode,
    OAuthCallback requestOAuth,
  ) async {
    final state = const Uuid().v4();

    const redirectUri = "https://kaiteki.app/oauth";
    await launchUrl(
      Uri.https(
        "tumblr.com",
        "/oauth2/authorize",
        {
          "response_type": "code",
          "client_id": consumerKey,
          "redirect_uri": redirectUri,
          "scope": scopes.join(" "),
          "state": state,
        },
      ),
      mode: LaunchMode.externalApplication,
    );

    late final String code;

    await requestCode(
      const CodePromptOptions(),
      (input) async {
        final bytes = base64.decode(input);
        final json = utf8.decode(bytes);
        final params = jsonDecode(json) as Map<String, dynamic>;
        if (state != params["state"]) throw Exception("Invalid state");
        code = params["code"]! as String;
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

    return LoginResult.successful(
      Account(
        clientSecret: null,
        accountSecret: AccountSecret(
          tokenResponse.accessToken,
          tokenResponse.refreshToken,
          userInfoResponse.user.name,
        ),
        user: userInfoResponse.user.toKaiteki(),
        key: AccountKey(
          ApiType.tumblr,
          "tumblr.com",
          userInfoResponse.user.name,
        ),
        adapter: this,
      ),
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
}

extension _TumblrUserInfoKaitekiExtension on tumblr.UserInfo {
  User toKaiteki() {
    return User(
      username: name,
      id: name,
      displayName: null,
      followingCount: following,
      host: "tumblr.com",
    );
  }
}

extension _TumblrPostKaitekiExtension on tumblr.Post {
  Post toKaiteki() {
    List<Attachment> getAttachments(Element element) {
      if (element.localName != "img") {
        return element.children.expand(getAttachments).toList();
      }

      return [
        Attachment(
          url: Uri.parse(element.attributes["src"]!),
          type: AttachmentType.image,
          previewUrl: null,
        ),
      ];
    }

    final fragment = body.nullTransform(parseFragment);
    return Post(
      author: blog.toKaiteki(),
      id: id,
      postedAt: DateTime.now(),
      content: body,
      subject: title,
      attachments: fragment?.children.expand(getAttachments).toList(),
    );
  }
}

extension _TumblrBlogKaitekiExtension on tumblr.Blog {
  User toKaiteki() {
    return User(
      username: name,
      id: name,
      displayName: title,
      host: "tumblr.com",
      avatarUrl: avatar?.lastOrNull?.url,
    );
  }
}
