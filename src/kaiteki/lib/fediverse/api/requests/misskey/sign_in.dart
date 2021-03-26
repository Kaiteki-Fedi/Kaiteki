import 'package:json_annotation/json_annotation.dart';
part 'sign_in.g.dart';

/// Defines the body as object for the "signin" endpoint on Misskey.
/// Reference: https://github.com/syuilo/misskey/blob/develop/src/server/api/private/signin.ts
@JsonSerializable(createFactory: false)
class MisskeySignInRequest {
  final String username;

  final String password;

  final String token;

  const MisskeySignInRequest({
    this.username,
    this.password,
    this.token,
  });

  Map<String, dynamic> toJson() => _$MisskeySignInRequestToJson(this);
}
