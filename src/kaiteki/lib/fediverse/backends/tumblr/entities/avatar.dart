import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/utils/utils.dart";

part "avatar.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class Avatar {
  final int width;
  final int height;
  final Uri url;

  const Avatar({
    required this.width,
    required this.height,
    required this.url,
  });

  factory Avatar.fromJson(JsonMap json) => _$AvatarFromJson(json);
}
