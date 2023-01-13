import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/fediverse/backends/twitter/v1/model/entities/entity.dart";
import "package:kaiteki/utils/utils.dart";

part "hashtag.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class Hashtag extends Entity {
  /// Name of the hashtag, minus the leading ‘#’ character.
  final String text;

  const Hashtag({
    required this.text,
    required List<int> indices,
  }) : super(indices);

  factory Hashtag.fromJson(JsonMap json) => _$HashtagFromJson(json);

  JsonMap toJson() => _$HashtagToJson(this);
}
