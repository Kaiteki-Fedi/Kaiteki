import 'dart:async';

import 'package:kaiteki_core/src/social/interfaces/login_support.dart';
import 'package:meta/meta.dart';

import 'capabilities.dart';
import 'model/attachment.dart';
import 'model/instance.dart';
import 'model/post.dart';
import 'model/timeline_query.dart';
import 'model/timeline_type.dart';
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

  /// Whether any secret is set.
  bool authenticated = false;

  /// Retrieves the profile of the currently authenticated user.
  Future<User> getMyself();

  @mustCallSuper
  FutureOr<void> applySecrets(
    ClientSecret? clientSecret,
    UserSecret userSecret,
  ) {
    authenticated = true;
  }

  /// Retrieves an user of another instance
  Future<User?> getUser(String username, [String? instance]);

  /// Retrieves an user using an instance specific ID.
  Future<User?> getUserById(String id);

  /// Posts a status, optionally in reply to another post.
  Future<Post> postStatus(PostDraft draft, {Post? parentPost});

  /// Retrieves the thread of a post.
  Future<Iterable<Post>> getThread(String postId);

  Future<List<Post>> getTimeline(
    TimelineType type, {
    TimelineQuery<String>? query,
    PostFilter? filter,
  });

  Future<List<Post>> getPostsOfUserById(
    String id, {
    TimelineQuery<String>? query,
    PostFilter? filter,
  });

  FutureOr<Instance> getInstance();

  /// Retrieves a post.
  Future<Post> getPostById(String id);

  /// Repeats a post.
  Future<void> repeatPost(String id);

  /// Unrepeats a post.
  Future<void> unrepeatPost(String id);

  Future<Attachment> uploadAttachment(AttachmentDraft draft);

  Future<List<User>> getRepeatees(String id);

  Future<User> lookupUser(String username, [String? host]);

  Future<Object?> resolveUrl(Uri url);
}
