import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/fediverse/backends/tumblr/entities/blog.dart";

part "post.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class Post {
  @JsonKey(name: "id_string")
  final String id;
  final Blog blog;
  final bool canLike;
  final bool canReblog;
  final bool isBlazed;
  final bool isBlazePending;
  final bool isBlocksPostFormat;
  final bool? bookmarklet;
  final bool? liked;
  final int noteCount;
  final int timestamp;
  final int? totalPosts;
  final List<String> tags;
  final PostFormat format;
  final PostState state;
  final String blogName;
  final String date;
  final String reblogKey;
  final String slug;
  final String summary;
  final String? title;
  final String type;
  final String? body;
  final String? sourceTitle;
  final Uri postUrl;
  final Uri shortUrl;
  final Uri? sourceUrl;

  const Post({
    required this.blog,
    required this.blogName,
    this.body,
    required this.bookmarklet,
    required this.canLike,
    required this.canReblog,
    required this.date,
    required this.format,
    required this.id,
    required this.isBlazed,
    required this.isBlazePending,
    required this.isBlocksPostFormat,
    required this.liked,
    required this.noteCount,
    required this.postUrl,
    required this.reblogKey,
    required this.shortUrl,
    required this.slug,
    required this.sourceTitle,
    required this.sourceUrl,
    required this.state,
    required this.summary,
    required this.tags,
    required this.timestamp,
    this.title,
    required this.totalPosts,
    required this.type,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}

enum PostState { published, queued, draft, private }

enum PostFormat { html, markdown }
