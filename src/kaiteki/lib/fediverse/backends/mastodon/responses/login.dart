import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class LoginResponse {
  final String? accessToken;
  final int? expiresIn;
  final String? me;
  final String? refreshToken;
  final String? scope;
  final String? tokenType;
  final String? error;
  final String? mfaToken;

  const LoginResponse(
    this.accessToken,
    this.expiresIn,
    this.me,
    this.refreshToken,
    this.scope,
    this.tokenType,
    this.error,
    this.mfaToken,
  );

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
