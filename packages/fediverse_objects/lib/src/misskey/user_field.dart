import 'package:json_annotation/json_annotation.dart';

part 'user_field.g.dart';

@JsonSerializable()
class UserField {
  final String name;
  final String value;

  const UserField({
    required this.name,
    required this.value,
  });

  factory UserField.fromJson(Map<String, dynamic> json) =>
      _$UserFieldFromJson(json);
}
