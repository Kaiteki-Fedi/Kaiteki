import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';

abstract class SearchSupport {
  Future<SearchResults> searchAll(String query);

  Future<List<User>> searchUsers(String query) async {
    final results = await searchAll(query);
    return results.users;
  }

  Future<List<Post>> searchPosts(String query) async {
    final results = await searchAll(query);
    return results.posts;
  }
}

class SearchResults {
  final List<User> users;
  final List<Post> posts;
  // final List<Hashtag> hashtags;

  const SearchResults({
    required this.users,
    required this.posts,
  });
}
