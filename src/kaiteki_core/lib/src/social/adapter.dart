import 'dart:async';

import 'package:kaiteki_core/src/social/interfaces/login_support.dart';

import 'api_type.dart';
import 'capabilities.dart';
import 'model/attachment.dart';
import 'model/instance.dart';
import 'model/pagination.dart';
import 'model/post.dart';
import 'model/timeline_kind.dart';
import 'model/timeline_query.dart';
import 'model/user.dart';

abstract class CentralizedBackendAdapter extends BackendAdapter {
  Instance get instance;

  @override
  FutureOr<Instance> getInstance() => instance;
}

abstract class DecentralizedBackendAdapter extends BackendAdapter {
  String get instance;

  Future<Instance?> probeInstance();
}

abstract class BackendAdapter {
  AdapterCapabilities get capabilities;
  ApiType get type;

  /// Retrieves the profile of the currently authenticated user.
  Future<User> getMyself();

  FutureOr<void> applySecrets(
    ClientSecret? clientSecret,
    UserSecret userSecret,
  );

  /// Retrieves an user of another instance
  Future<User> getUser(String username, [String? instance]);

  /// Retrieves an user using an instance specific ID.
  Future<User> getUserById(String id);

  /// Posts a status, optionally in reply to another post.
  Future<Post> postStatus(PostDraft draft, {Post? parentPost});

  /// Retrieves a thread from a reply
  Future<Iterable<Post>> getThread(Post reply);

  Future<List<Post>> getTimeline(
    TimelineKind type, {
    TimelineQuery<String>? query,
  });

  Future<List<Post>> getStatusesOfUserById(
    String id, {
    TimelineQuery<String>? query,
  });

  FutureOr<Instance> getInstance();

  /// Retrieves a post.
  Future<Post> getPostById(String id);

  /// Repeats a post.
  Future<void> repeatPost(String id);

  /// Unrepeats a post.
  Future<void> unrepeatPost(String id);

  /// Follows an user.
  ///
  /// May return a [User] with updated user state, otherwise throw on error.
  Future<User?> followUser(String id);

  /// Unfollows an user.
  ///
  /// May return a [User] with updated user state, otherwise throw on error.
  Future<User?> unfollowUser(String id);

  Future<Attachment> uploadAttachment(AttachmentDraft draft);

  Future<List<User>> getRepeatees(String id);

  /// Deletes the user's account.
  Future<void> deleteAccount(String password);

  Future<PaginatedList<String?, User>> getFollowers(
    String userId, {
    String? sinceId,
    String? untilId,
  });

  Future<PaginatedList<String?, User>> getFollowing(
    String userId, {
    String? sinceId,
    String? untilId,
  });

  Future<User> lookupUser(String username, [String? host]);
}
