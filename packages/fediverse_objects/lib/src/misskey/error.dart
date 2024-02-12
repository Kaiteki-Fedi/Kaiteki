import 'package:json_annotation/json_annotation.dart';
part 'error.g.dart';

@JsonSerializable()
class Error {
  /// An error code. Unique within the endpoint.
  final String? code;

  /// An error message.
  final String? message;

  /// An error ID. This ID is static.
  final String? id;

  const Error({
    this.code,
    this.message,
    this.id,
  });

  factory Error.fromJson(Map<String, dynamic> json) => _$ErrorFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorToJson(this);
}
