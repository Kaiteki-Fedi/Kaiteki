import "dart:async";

import "package:kaiteki/auth/login_typedefs.dart";
import "package:kaiteki/fediverse/api_type.dart";
import "package:kaiteki/fediverse/capabilities.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/fediverse/model/timeline_query.dart";
import "package:kaiteki/model/auth/login_result.dart";
import "package:kaiteki/model/auth/secret.dart";
import "package:kaiteki/model/file.dart";

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

  /// Retrieves the profile of the currently authenticated user.
  Future<User> getMyself();

  FutureOr<void> applySecrets(
    ClientSecret? clientSecret,
    AccountSecret accountSecret,
  );

  /// Attempts to sign into an instance. Additionally, callback methods
  /// provided in the parameters can be used to request more data from
  /// the user, if required.
  Future<LoginResult> login(
    ClientSecret? clientSecret,
    CredentialsCallback requestCredentials,
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
  /// This method *may* return a [User] with updated information depending on
  /// the adapter implementation.
  Future<User?> followUser(String id);

  Future<Attachment> uploadAttachment(File file, String? description);

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
}

extension FediverseAdapterExtensions on BackendAdapter {
  ApiType get type => ApiType.values.firstWhere((t) => t.isType(this));
}
