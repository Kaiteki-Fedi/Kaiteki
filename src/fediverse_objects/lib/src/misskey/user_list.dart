import 'package:json_annotation/json_annotation.dart';

part 'user_list.g.dart';

@JsonSerializable()
class UserList {
  /// The unique identifier for this UserList.
  @JsonKey(name: 'id')
  final String id;

  /// The date that the UserList was created.
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  /// The name of the UserList.
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'userIds')
  final Iterable<String> userIds;

  const UserList({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.userIds,
  });

  factory UserList.fromJson(Map<String, dynamic> json) =>
      _$UserListFromJson(json);
  Map<String, dynamic> toJson() => _$UserListToJson(this);
}
