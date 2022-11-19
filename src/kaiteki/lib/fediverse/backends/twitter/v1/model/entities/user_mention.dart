import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/fediverse/backends/twitter/v1/model/entities/entity.dart';

part 'user_mention.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserMention extends Entity {
  final int id;
  final String idStr;
  final String name;
  final String screenName;

  const UserMention({
    required this.id,
    required this.idStr,
    required this.name,
    required this.screenName,
    required List<int> indices,
  }) : super(indices);

  factory UserMention.fromJson(Map<String, dynamic> json) =>
      _$UserMentionFromJson(json);

  Map<String, dynamic> toJson() => _$UserMentionToJson(this);
}
