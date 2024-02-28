import "dart:async";

import "package:cross_file/cross_file.dart";
import "package:kaiteki_core/kaiteki_core.dart";

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
  Future<Instance> getInstance() async => instance;

  @override
  Future<User> getMyself() async => alice;

  @override
  Future<Post> getPostById(String id) => throw UnimplementedError();

  @override
  Future<List<User>> getRepeatees(String id) => throw UnimplementedError();

  @override
  Future<List<Post>> getPostsOfUserById(
    String id, {
    TimelineQuery<String>? query,
    PostFilter? filter,
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
  Future<Iterable<Post>> getThread(String postId) => throw UnimplementedError();

  @override
  Future<List<Post>> getTimeline(
    TimelineType type, {
    TimelineQuery<String>? query,
    PostFilter? filter,
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
  Future<Attachment> uploadAttachment(AttachmentDraft draft) =>
      throw UnimplementedError();

  @override
  Future<User> lookupUser(String username, [String? host]) =>
      throw UnimplementedError();

  @override
  Future<Object?> resolveUrl(Uri url) => throw UnimplementedError();

  @override
  Future<ProfileSettings> getProfileSettings() {
    // TODO: implement getProfileSettings
    throw UnimplementedError();
  }

  @override
  Future<void> setAvatar(XFile? image) {
    // TODO: implement setAvatar
    throw UnimplementedError();
  }

  @override
  Future<void> setBackground(XFile? image) {
    // TODO: implement setBackground
    throw UnimplementedError();
  }

  @override
  Future<void> setBanner(XFile? image) {
    // TODO: implement setBanner
    throw UnimplementedError();
  }

  @override
  Future<void> setProfileSettings(ProfileSettings settings) {
    // TODO: implement setProfileSettings
    throw UnimplementedError();
  }
}

class DummyAdapterCapability extends AdapterCapabilities {
  @override
  Set<Formatting> get supportedFormattings => Formatting.values.toSet();

  @override
  Set<PostScope> get supportedScopes => PostScope.values.toSet();

  @override
  Set<TimelineType> get supportedTimelines => TimelineType.values.toSet();

  @override
  bool get supportsSubjects => true;
}
