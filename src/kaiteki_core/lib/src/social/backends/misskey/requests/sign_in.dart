import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';

part 'sign_in.g.dart';

/// <https://github.com/syuilo/misskey/blob/develop/src/server/api/private/signin.ts>
@JsonSerializable()
class MisskeySignInRequest {
  final String username;

  final String password;

  final String? token;

  const MisskeySignInRequest({
    required this.username,
    required this.password,
    this.token,
  });

  factory MisskeySignInRequest.fromJson(JsonMap json) =>
      _$MisskeySignInRequestFromJson(json);

  JsonMap toJson() => _$MisskeySignInRequestToJson(this);
}
