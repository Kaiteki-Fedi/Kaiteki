import 'package:json_annotation/json_annotation.dart';

part 'user_group.g.dart';

@JsonSerializable()
class UserGroup {
  /// The unique identifier for this UserGroup.
  @JsonKey(name: 'id')
  final String id;

  /// The date that the UserGroup was created.
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  /// The name of the UserGroup.
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'ownerId')
  final String ownerId;

  @JsonKey(name: 'userIds')
  final Iterable<String> userIds;

  const UserGroup({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.ownerId,
    required this.userIds,
  });

  factory UserGroup.fromJson(Map<String, dynamic> json) =>
      _$UserGroupFromJson(json);
  Map<String, dynamic> toJson() => _$UserGroupToJson(this);
}
