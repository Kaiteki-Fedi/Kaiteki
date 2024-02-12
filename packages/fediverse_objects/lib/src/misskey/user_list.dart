import 'package:json_annotation/json_annotation.dart';
part 'user_list.g.dart';

@JsonSerializable()
class UserList {
  final String id;

  final DateTime createdAt;

  final String name;

  final List<String>? userIds;

  const UserList({
    required this.id,
    required this.createdAt,
    required this.name,
    this.userIds,
  });

  factory UserList.fromJson(Map<String, dynamic> json) =>
      _$UserListFromJson(json);
  Map<String, dynamic> toJson() => _$UserListToJson(this);
}
