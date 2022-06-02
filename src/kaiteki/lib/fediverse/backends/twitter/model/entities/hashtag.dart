import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/fediverse/backends/twitter/model/entities/entity.dart';

part 'hashtag.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Hashtag extends Entity {
  /// Name of the hashtag, minus the leading ‘#’ character.
  final String text;

  const Hashtag({
    required this.text,
    required List<int> indices,
  }) : super(indices);

  factory Hashtag.fromJson(Map<String, dynamic> json) =>
      _$HashtagFromJson(json);

  Map<String, dynamic> toJson() => _$HashtagToJson(this);
}
