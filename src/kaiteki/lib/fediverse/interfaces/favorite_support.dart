import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';

abstract class FavoriteSupport {
  /// Favorites a post.
  ///
  /// This method *may* return a [Post] that was favorited.
  Future<Post?> favoritePost(String id);

  /// Unfavorites a post.
  ///
  /// This method *may* return the [Post] that was unfavorited.
  Future<Post?> unfavoritePost(String id);

  /// Returns a list of users that have favorited this post.
  Future<List<User>> getFavoritees(String id);
}
