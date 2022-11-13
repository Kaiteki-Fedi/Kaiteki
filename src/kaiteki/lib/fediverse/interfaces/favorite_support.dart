import 'package:kaiteki/fediverse/model/user.dart';

abstract class FavoriteSupport {
  /// Favorites a post.
  Future<void> favoritePost(String id);

  /// Unfavorites a post.
  Future<void> unfavoritePost(String id);

  /// Returns a list of users that have favorited this post.
  Future<List<User>> getFavoritees(String id);
}
