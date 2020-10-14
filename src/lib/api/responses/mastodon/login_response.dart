import 'package:json_annotation/json_annotation.dart';
part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: "access_token")
  final String accessToken;

  @JsonKey(name: "expires_in")
  final int expiresIn;

  final String me;

  @JsonKey(name: "refresh_token")
  final String refreshToken;

  final String scope;

  @JsonKey(name: "token_type")
  final String tokenType;

  final String error;

  @JsonKey(name: "mfa_token")
  final String mfaToken;

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

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
}