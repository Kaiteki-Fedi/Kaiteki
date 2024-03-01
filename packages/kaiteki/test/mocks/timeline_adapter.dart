import "package:cross_file/cross_file.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

class TimelineAdapter extends BackendAdapter {
  final Set<TimelineType> brokenTimelines;

  @override
  final TimelineAdapterCapabilities capabilities;

  TimelineAdapter(
    this.capabilities, [
    this.brokenTimelines = const {},
  ]);

  @override
  FutureOr<Instance> getInstance() => throw UnimplementedError();

  @override
  Future<User> getMyself() => throw UnimplementedError();

  @override
  Future<Post> getPostById(String id) => throw UnimplementedError();

  @override
  Future<List<User>> getRepeatees(String id) => throw UnimplementedError();

  @override
  Future<List<Post>> getPostsOfUserById(
    String id, {
    TimelineQuery<String>? query,
    PostFilter? filter,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Post>> getThread(String postId) => throw UnimplementedError();

  @override
  Future<List<Post>> getTimeline(
    TimelineType type, {
    TimelineQuery<String>? query,
    PostFilter? filter,
  }) async {
    if (brokenTimelines.contains(type)) throw UnimplementedError();
    return [
      if (query?.sinceId == null && query?.untilId == null)
        Post(
          postedAt: DateTime.now(),
          author: const User(
            displayName: "User",
            host: "example.social",
            id: "0",
            username: "User",
          ),
          id: DateTime.now().toIso8601String(),
          content: type.toString(),
        ),
    ];
  }

  @override
  Future<User> getUser(String username, [String? instance]) =>
      throw UnimplementedError();

  @override
  Future<User> getUserById(String id) => throw UnimplementedError();

  @override
  Future<Post> postStatus(PostDraft draft, {Post? parentPost}) =>
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

  @override
  Future<void> deletePost(String id) => throw UnimplementedError();
}

class TimelineAdapterCapabilities extends AdapterCapabilities {
  TimelineAdapterCapabilities([this.supportedTimelines = const {}]);

  @override
  Set<Formatting> get supportedFormattings => {};

  @override
  Set<PostScope> get supportedScopes => {};

  @override
  final Set<TimelineType> supportedTimelines;

  @override
  bool get supportsSubjects => false;
}
