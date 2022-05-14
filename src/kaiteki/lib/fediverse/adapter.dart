import 'dart:async';

import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/auth/login_typedefs.dart';
import 'package:kaiteki/fediverse/client_base.dart';
import 'package:kaiteki/fediverse/model/emoji_category.dart';
import 'package:kaiteki/fediverse/model/instance.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/post_draft.dart';
import 'package:kaiteki/fediverse/model/timeline_type.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/model/auth/login_result.dart';

/// An adapter containing a backing Fediverse client that.
abstract class FediverseAdapter<Client extends FediverseClientBase> {
  /// The original client/backend that is being adapted.
  Client client;

  FediverseAdapter(this.client);

  /// Retrieves the profile of the currently authenticated user.
  Future<User> getMyself();

  /// Attempts to sign into an instance. Additionally, mfaCallback can be used
  /// to request more data from the user, if required.
  Future<LoginResult> login(
    String instance,
    String username,
    String password,
    MfaCallback mfaCallback,
    AccountManager accounts,
  );

  /// Retrieves an user of another instance
  Future<User> getUser(String username, [String? instance]);

  /// Retrieves an user using an instance specific ID.
  Future<User> getUserById(String id);

  /// Posts a status, optionally in reply to another post.
  Future<Post> postStatus(PostDraft draft, {Post? parentPost});

  /// Retrieves a thread from a reply
  Future<Iterable<Post>> getThread(Post reply);

  Future<Iterable<Post>> getTimeline(
    TimelineType type, {
    String? sinceId,
    String? untilId,
  });

  Future<Iterable<Post>> getStatusesOfUserById(String id);

  Future<Iterable<EmojiCategory>> getEmojis();

  Future<Instance> getInstance();

  Future<Instance?> probeInstance();

  /// Retrieves a post.
  Future<Post> getPostById(String id);

  /// Favorites a post.
  ///
  /// This method *may* return a [Post] with updated information depending on
  /// the adapter implementation.
  Future<Post?> favoritePost(String id);

  /// Follows an user.
  ///
  /// This method *may* return a [User] with updated information depending on
  /// the adapter implementation.
  Future<User?> followUser(String id);
}
