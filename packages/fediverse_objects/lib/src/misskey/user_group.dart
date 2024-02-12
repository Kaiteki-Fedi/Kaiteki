import 'package:json_annotation/json_annotation.dart';
part 'user_group.g.dart';

@JsonSerializable()
class UserGroup {
  final String id;

  final DateTime createdAt;

  final String name;

  final String ownerId;

  final List<String>? userIds;

  const UserGroup({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.ownerId,
    this.userIds,
  });

  factory UserGroup.fromJson(Map<String, dynamic> json) =>
      _$UserGroupFromJson(json);
  Map<String, dynamic> toJson() => _$UserGroupToJson(this);
}
