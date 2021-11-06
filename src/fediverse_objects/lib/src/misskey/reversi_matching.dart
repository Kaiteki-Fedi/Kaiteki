import 'package:fediverse_objects/src/misskey/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reversi_matching.g.dart';

@JsonSerializable()
class ReversiMatching {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'parentId')
  final String parentId;

  @JsonKey(name: 'parent')
  final User? parent;

  @JsonKey(name: 'childId')
  final String childId;

  @JsonKey(name: 'child')
  final User child;

  const ReversiMatching({
    required this.id,
    required this.createdAt,
    required this.parentId,
    this.parent,
    required this.childId,
    required this.child,
  });

  factory ReversiMatching.fromJson(Map<String, dynamic> json) =>
      _$ReversiMatchingFromJson(json);

  Map<String, dynamic> toJson() => _$ReversiMatchingToJson(this);
}
