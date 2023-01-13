import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/utils/utils.dart";

part "login.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class LoginResponse {
  final String? accessToken;
  final int? expiresIn;
  final String? me;
  final String? refreshToken;
  final String? scope;
  final String? tokenType;

  const LoginResponse(
    this.accessToken,
    this.expiresIn,
    this.me,
    this.refreshToken,
    this.scope,
    this.tokenType,
  );

  factory LoginResponse.fromJson(JsonMap json) => _$LoginResponseFromJson(json);
}
