import 'package:kaiteki/fediverse/model/model.dart';

abstract class SearchSupport {
  Future<SearchResults> search(String query) async {
    final users = await searchForUsers(query);
    final posts = await searchForPosts(query);
    final hashtags = await searchForHashtags(query);
    return SearchResults(
      users: users,
      posts: posts,
      hashtags: hashtags,
    );
  }

  Future<List<User>> searchForUsers(String query) async {
    final results = await search(query);
    return results.users;
  }

  Future<List<Post>> searchForPosts(String query) async {
    final results = await search(query);
    return results.posts;
  }

  Future<List<String>> searchForHashtags(String query) async {
    final results = await search(query);
    return results.hashtags;
  }
}

class SearchResults {
  final List<User> users;
  final List<Post> posts;
  final List<String> hashtags;

  const SearchResults({
    this.users = const [],
    this.posts = const [],
    this.hashtags = const [],
  });
}
