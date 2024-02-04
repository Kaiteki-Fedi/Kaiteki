import 'package:kaiteki_core/src/social/model/post.dart';

abstract class BookmarkSupport {
  /// Adds a post to the bookmarks.
  Future<void> bookmarkPost(String id);

  /// Removes a post from the bookmarks.
  Future<void> unbookmarkPost(String id);

  /// Fetches a list of bookmarks the user has made.
  Future<List<Post>> getBookmarks({
    String? maxId,
    String? sinceId,
    String? minId,
  });
}
