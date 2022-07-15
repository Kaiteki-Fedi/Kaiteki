import 'package:json_annotation/json_annotation.dart';

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

  factory MisskeySignInRequest.fromJson(Map<String, dynamic> json) =>
      _$MisskeySignInRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeySignInRequestToJson(this);
}
