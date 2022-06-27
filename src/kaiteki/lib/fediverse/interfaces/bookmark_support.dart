import 'package:kaiteki/fediverse/model/post.dart';

abstract class BookmarkSupport {
  /// Adds a post to the bookmarks.
  ///
  /// This method *may* return a [Post] that was added to the bookmarks.
  Future<Post?> bookmarkPost(String id);

  /// Removes a post from the bookmarks.
  ///
  /// This method *may* return the [Post] that was removed from the bookmarks.
  Future<Post?> unbookmarkPost(String id);

  /// Fetches a list of bookmarks the user has made.
  Future<List<Post>> getBookmarks();
}
