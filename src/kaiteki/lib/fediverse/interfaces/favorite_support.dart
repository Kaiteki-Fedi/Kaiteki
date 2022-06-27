import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/post_draft.dart';

abstract class FavoriteSupport {
  /// Favorites a post.
  ///
  /// This method *may* return a [Post] that was favorited.
  Future<Post?> favoritePost(String id);

  /// Unfavorites a post.
  ///
  /// This method *may* return the [Post] that was unfavorited.
  Future<Post?> unfavoritePost(String id);
}
