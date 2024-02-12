import 'package:json_annotation/json_annotation.dart';

part 'role.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Role {
  final int id;
  final String name;
  final String color;
  final int permissions;
  final bool highlighted;

  const Role({
    required this.id,
    required this.name,
    required this.color,
    required this.permissions,
    required this.highlighted,
  });

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

  Map<String, dynamic> toJson() => _$RoleToJson(this);
}
