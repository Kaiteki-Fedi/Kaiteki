import 'package:kaiteki_core/kaiteki_core.dart';

abstract class FollowSupport {
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

  Future<PaginatedSet<String?, User>> getFollowRequests({
    String? sinceId,
    String? untilId,
  });

  Future<void> acceptFollowRequest(String userId);

  Future<void> rejectFollowRequest(String userId);

  /// Follows an user.
  ///
  /// May return a [User] with updated user state, otherwise throw on error.
  Future<User?> followUser(String id);

  /// Unfollows an user.
  ///
  /// May return a [User] with updated user state, otherwise throw on error.
  Future<User?> unfollowUser(String id);
}
