import 'dart:async';

import 'package:kaiteki/auth/login_typedefs.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/capabilities.dart';
import 'package:kaiteki/fediverse/client_base.dart';
import 'package:kaiteki/fediverse/model/model.dart';
import 'package:kaiteki/fediverse/model/timeline_query.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/model/auth/login_result.dart';
import 'package:kaiteki/model/file.dart';

import 'example_data.dart';

class DummyClient extends FediverseClientBase {
  DummyClient(super.instance);

  @override
  FutureOr<void> setAccountAuthentication(
    AccountSecret secret,
  ) =>
      throw UnimplementedError();

  @override
  ApiType get type => ApiType.mastodon;
}

class DummyAdapter extends FediverseAdapter<DummyClient> {
  final List<Post> posts;
  final List<User> users;

  DummyAdapter(
    super.client, {
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
  Future<Iterable<Post>> getStatusesOfUserById(
    String id, {
    TimelineQuery<String>? query,
  }) async {
    final posts = this.posts.where((p) => p.author.id == id);

    final untilId = query?.untilId;
    if (untilId != null) {
      final dt = posts.firstWhere((p) => p.id == untilId).postedAt;
      return posts.where((p) => p.postedAt.isAfter(dt));
    }

    return posts;
  }

  @override
  Future<Iterable<Post>> getThread(Post reply) => throw UnimplementedError();

  @override
  Future<Iterable<Post>> getTimeline(
    TimelineKind type, {
    TimelineQuery<String>? query,
  }) async {
    final untilId = query?.untilId;
    if (untilId != null) {
      final dt = posts.firstWhere((p) => p.id == untilId).postedAt;
      return posts.where((p) => p.postedAt.isAfter(dt));
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
  Future<Instance?> probeInstance() async => null;

  @override
  Future<void> repeatPost(String id) => throw UnimplementedError();

  @override
  Future<void> unrepeatPost(String id) => throw UnimplementedError();

  @override
  Future<Attachment> uploadAttachment(
    File file,
    String? description,
  ) =>
      throw UnimplementedError();
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
