import 'package:json_annotation/json_annotation.dart';

part 'user_list.g.dart';

@JsonSerializable()
class UserList {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'userIds')
  final Iterable<String>? userIds;

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
