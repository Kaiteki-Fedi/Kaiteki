import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/utils/utils.dart";

part "token_response.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class TokenResponse {
  final String tokenType;
  final int expiresIn;
  final String accessToken;
  final String scope;
  final String refreshToken;

  const TokenResponse({
    required this.tokenType,
    required this.expiresIn,
    required this.accessToken,
    required this.scope,
    required this.refreshToken,
  });

  factory TokenResponse.fromJson(JsonMap json) => _$TokenResponseFromJson(json);

  JsonMap toJson() => _$TokenResponseToJson(this);
}
