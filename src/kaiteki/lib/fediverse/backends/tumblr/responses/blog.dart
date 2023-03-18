import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/fediverse/backends/tumblr/entities/blog.dart";
import "package:kaiteki/utils/utils.dart";

part "blog.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class BlogInfoResponse {
  final Blog blog;

  const BlogInfoResponse({
    required this.blog,
  });

  factory BlogInfoResponse.fromJson(JsonMap json) =>
      _$BlogInfoResponseFromJson(json);
}
