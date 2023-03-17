import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/fediverse/backends/tumblr/entities/blog.dart";
import "package:kaiteki/utils/utils.dart";

part "user_info.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class UserInfo {
  final int following;
  final String defaultPostFormat;
  final List<Blog> blogs;
  final int likes;
  final String name;

  const UserInfo({
    required this.following,
    required this.defaultPostFormat,
    required this.likes,
    required this.blogs,
    required this.name,
  });

  factory UserInfo.fromJson(JsonMap json) => _$UserInfoFromJson(json);
}
