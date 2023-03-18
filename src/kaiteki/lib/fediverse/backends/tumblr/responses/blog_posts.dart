import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/fediverse/backends/tumblr/entities/blog.dart";
import "package:kaiteki/fediverse/backends/tumblr/entities/post.dart";
import "package:kaiteki/utils/utils.dart";

part "blog_posts.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class BlogPostsResponse {
  final List<Post> posts;
  final Blog blog;
  final int totalPosts;

  const BlogPostsResponse({
    required this.posts,
    required this.blog,
    required this.totalPosts,
  });

  factory BlogPostsResponse.fromJson(JsonMap json) =>
      _$BlogPostsResponseFromJson(json);
}
