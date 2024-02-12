import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';

part 'token.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TokenResponse {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final String refreshToken;
  final String scope;

  const TokenResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.refreshToken,
    required this.scope,
  });

  factory TokenResponse.fromJson(JsonMap json) => _$TokenResponseFromJson(json);
}
