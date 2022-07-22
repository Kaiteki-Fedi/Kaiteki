import 'dart:async';

import 'package:kaiteki/auth/login_typedefs.dart';
import 'package:kaiteki/fediverse/capabilities.dart';
import 'package:kaiteki/fediverse/client_base.dart';
import 'package:kaiteki/fediverse/model/attachment.dart';
import 'package:kaiteki/fediverse/model/instance.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/post_draft.dart';
import 'package:kaiteki/fediverse/model/timeline_kind.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/model/auth/login_result.dart';
import 'package:kaiteki/model/file.dart';

/// An adapter containing a backing Fediverse client that.
abstract class FediverseAdapter<Client extends FediverseClientBase> {
  /// The original client/backend that is being adapted.
  final Client client;

  String get instance => client.instance;

  AdapterCapabilities get capabilities;

  FediverseAdapter(this.client);

  /// Retrieves the profile of the currently authenticated user.
  Future<User> getMyself();

  /// Attempts to sign into an instance. Additionally, callback methods
  /// provided in the parameters can be used to request more data from
  /// the user, if required.
  Future<LoginResult> login(
    ClientSecret? clientSecret,
    String username,
    String password,
    MfaCallback requestMfa,
    OAuthCallback requestOAuth,
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
    TimelineKind type, {
    String? sinceId,
    String? untilId,
  });

  Future<Iterable<Post>> getStatusesOfUserById(String id);

  Future<Instance> getInstance();

  Future<Instance?> probeInstance();

  /// Retrieves a post.
  Future<Post> getPostById(String id);

  /// Repeats a post.
  ///
  /// This method *may* return a [Post] containing the repeated post.
  Future<Post?> repeatPost(String id);

  /// Unrepeats a post.
  ///
  /// This method *may* return the [Post] that was unrepeated.
  Future<Post?> unrepeatPost(String id);

  /// Follows an user.
  ///
  /// This method *may* return a [User] with updated information depending on
  /// the adapter implementation.
  Future<User?> followUser(String id);

  Future<Attachment> uploadAttachment(File file, String? description);
}
