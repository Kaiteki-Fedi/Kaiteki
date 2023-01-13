import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/fediverse/model/timeline_query.dart";

abstract class ListSupport {
  Future<List<PostList>> getLists();
  Future<List<User>> getListUsers(String listId);
  Future<PostList> createList(String title);
  Future<List<Post>> getListPosts(
    String listId, {
    TimelineQuery<String>? query,
  });
  Future<void> addUserToList(String listId, User user);
  Future<void> removeUserFromList(String listId, User user);
  Future<void> deleteList(String listId);
  Future<void> renameList(String listId, String name);
}
