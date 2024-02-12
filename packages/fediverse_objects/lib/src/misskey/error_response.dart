import 'package:json_annotation/json_annotation.dart';

import 'error.dart';

part 'error_response.g.dart';

@JsonSerializable()
class ErrorResponse {
  /// An error object.
  final Error error;

  const ErrorResponse({
    required this.error,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}
