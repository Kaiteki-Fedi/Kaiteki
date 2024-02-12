import 'package:json_annotation/json_annotation.dart';

part 'field.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Field {
  final String name;

  final String value;

  /// Timestamp of when the server verified a URL value for a rel=“me” link.
  ///
  /// String (ISO 8601 Datetime) if value is a verified URL. Otherwise, null.
  final DateTime? verifiedAt;

  const Field({
    required this.name,
    required this.value,
    this.verifiedAt,
  });

  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);

  Map<String, dynamic> toJson() => _$FieldToJson(this);
}
