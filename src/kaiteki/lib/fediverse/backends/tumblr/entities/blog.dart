import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/utils/utils.dart";

part "blog.g.dart";

@JsonSerializable()
class Blog {
  final String name;
  final Uri url;
  final String title;
  final bool primary;
  final int followers;
  final String tweet;
  final BlogType type;

  const Blog({
    required this.name,
    required this.url,
    required this.title,
    required this.primary,
    required this.followers,
    required this.tweet,
    required this.type,
  });

  factory Blog.fromJson(JsonMap json) => _$BlogFromJson(json);
}

enum BlogType {
  @JsonValue("public")
  public,

  @JsonValue("private")
  private,
}
