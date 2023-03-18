import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/fediverse/backends/tumblr/entities/avatar.dart";
import "package:kaiteki/fediverse/backends/tumblr/entities/blog_theme.dart";
import "package:kaiteki/utils/utils.dart";

part "blog.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class Blog {
  final BlogTheme? theme;
  final BlogType? type;
  final bool? ask;
  final bool? askAnon;
  final bool? followed;
  final bool? isBlockedFromPrimary;
  final bool? primary;
  final int? followers;
  final int? likes;
  final int? posts;
  final List<Avatar>? avatar;
  final String name;
  final String title;
  final String? description;
  final Uri url;

  const Blog({
    this.followers,
    required this.name,
    this.primary,
    required this.title,
    this.type,
    required this.url,
    this.ask,
    this.askAnon,
    this.avatar,
    this.description,
    required this.followed,
    this.isBlockedFromPrimary,
    this.likes,
    this.posts,
    this.theme,
  });

  factory Blog.fromJson(JsonMap json) => _$BlogFromJson(json);
}

enum BlogType {
  @JsonValue("public")
  public,

  @JsonValue("private")
  private,
}
