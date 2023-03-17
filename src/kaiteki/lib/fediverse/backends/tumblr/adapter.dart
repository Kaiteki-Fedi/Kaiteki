import "dart:async";
import "dart:convert";

import "package:kaiteki/auth/login_typedefs.dart";
import "package:kaiteki/fediverse/adapter.dart";
import "package:kaiteki/fediverse/backends/tumblr/client.dart";
import "package:kaiteki/fediverse/capabilities.dart";
import "package:kaiteki/fediverse/model/attachment.dart";
import "package:kaiteki/fediverse/model/instance.dart";
import "package:kaiteki/fediverse/model/pagination.dart";
import "package:kaiteki/fediverse/model/post/post.dart";
import "package:kaiteki/fediverse/model/timeline_kind.dart";
import "package:kaiteki/fediverse/model/timeline_query.dart";
import "package:kaiteki/fediverse/model/user/user.dart";
import "package:kaiteki/model/auth/login_result.dart";
import "package:kaiteki/model/auth/secret.dart";
import "package:url_launcher/url_launcher.dart";
import "package:uuid/uuid.dart";

const scopes = ["basic", "write", "offline_access"];
const consumerKey = "xxx";
const consumerSecret = "xxx";

class TumblrAdapter extends CentralizedBackendAdapter {
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
    // TODO: implement applySecrets
    throw UnimplementedError();
  }

  @override
  // TODO: implement capabilities
  AdapterCapabilities get capabilities => throw UnimplementedError();

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
  Future<User> getMyself() {
    // TODO: implement getMyself
    throw UnimplementedError();
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
  }) {
    // TODO: implement getStatusesOfUserById
    throw UnimplementedError();
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
  }) {
    // TODO: implement getTimeline
    throw UnimplementedError();
  }

  @override
  Future<User> getUser(String username, [String? instance]) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<User> getUserById(String id) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Instance get instance => const Instance(
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

    final response = await client.getToken(
      clientId: consumerKey,
      clientSecret: consumerSecret,
      code: code,
      redirectUri: redirectUri,
    );

    client.accessToken = response.accessToken;

    final user = await client.getUserInfo();

    return const LoginResult.aborted();
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
}
