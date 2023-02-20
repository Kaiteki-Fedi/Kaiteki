import "dart:async";

import "package:kaiteki/auth/login_typedefs.dart";
import "package:kaiteki/fediverse/adapter.dart";
import "package:kaiteki/fediverse/capabilities.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/fediverse/model/timeline_query.dart";
import "package:kaiteki/model/auth/login_result.dart";
import "package:kaiteki/model/auth/secret.dart";
import "package:kaiteki/model/file.dart";

import "example_data.dart";

class DummyAdapter extends BackendAdapter {
  final List<Post> posts;
  final List<User> users;

  DummyAdapter({
    this.posts = const [],
    this.users = const [],
  });

  @override
  AdapterCapabilities get capabilities => DummyAdapterCapability();

  @override
  Future<User?> followUser(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Instance> getInstance() async => instance;

  @override
  Future<User> getMyself() async => alice;

  @override
  Future<Post> getPostById(String id) => throw UnimplementedError();

  @override
  Future<List<User>> getRepeatees(String id) => throw UnimplementedError();

  @override
  Future<List<Post>> getStatusesOfUserById(
    String id, {
    TimelineQuery<String>? query,
  }) async {
    final posts = this.posts.where((p) => p.author.id == id);

    final untilId = query?.untilId;
    if (untilId != null) {
      final dt = posts.firstWhere((p) => p.id == untilId).postedAt;
      return posts.where((p) => p.postedAt.isAfter(dt)).toList();
    }

    return posts.toList();
  }

  @override
  Future<Iterable<Post>> getThread(Post reply) => throw UnimplementedError();

  @override
  Future<List<Post>> getTimeline(
    TimelineKind type, {
    TimelineQuery<String>? query,
  }) async {
    final untilId = query?.untilId;
    if (untilId != null) {
      final dt = posts.firstWhere((p) => p.id == untilId).postedAt;
      return posts.where((p) => p.postedAt.isAfter(dt)).toList();
    }

    return posts;
  }

  @override
  Future<User> getUser(
    String username, [
    String? instance,
  ]) =>
      throw UnimplementedError();

  @override
  Future<User> getUserById(String id) async {
    return users.firstWhere((u) => u.id == id);
  }

  @override
  Future<LoginResult> login(
    ClientSecret? clientSecret,
    CredentialsCallback requestCredentials,
    MfaCallback requestMfa,
    OAuthCallback requestOAuth,
  ) =>
      throw UnimplementedError();

  @override
  Future<Post> postStatus(
    PostDraft draft, {
    Post? parentPost,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> repeatPost(String id) => throw UnimplementedError();

  @override
  Future<void> unrepeatPost(String id) => throw UnimplementedError();

  @override
  Future<Attachment> uploadAttachment(File file, String? description) =>
      throw UnimplementedError();

  @override
  FutureOr<void> applySecrets(
    ClientSecret? clientSecret,
    AccountSecret accountSecret,
  ) {}

  @override
  Future<PaginatedList<String?, User>> getFollowers(
    String userId, {
    String? sinceId,
    String? untilId,
  }) =>
      throw UnimplementedError();

  @override
  Future<PaginatedList<String?, User>> getFollowing(
    String userId, {
    String? sinceId,
    String? untilId,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> deleteAccount(String password) => throw UnimplementedError();
}

class DummyAdapterCapability extends AdapterCapabilities {
  @override
  Set<Formatting> get supportedFormattings => Formatting.values.toSet();

  @override
  Set<Visibility> get supportedScopes => Visibility.values.toSet();

  @override
  Set<TimelineKind> get supportedTimelines => TimelineKind.values.toSet();

  @override
  bool get supportsSubjects => true;
}
