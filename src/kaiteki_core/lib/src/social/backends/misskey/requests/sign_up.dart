import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';

part 'sign_up.g.dart';

/// Defines the body as object for the "signup" endpoint on Misskey.
/// Reference: https://github.com/syuilo/misskey/blob/develop/src/server/api/private/signup.ts
@JsonSerializable()
class MisskeySignUpRequest {
  final String username;

  final String password;

  final String token;

  final String? invitationCode;

  /// The response from HCaptcha
  final String? hcaptchaResponse;

  /// The response from Google's ReCaptcha
  final String? recaptchaResponse;

  const MisskeySignUpRequest({
    required this.username,
    required this.password,
    required this.token,
    this.invitationCode,
    this.hcaptchaResponse,
    this.recaptchaResponse,
  });

  factory MisskeySignUpRequest.fromJson(JsonMap json) =>
      _$MisskeySignUpRequestFromJson(json);

  JsonMap toJson() => _$MisskeySignUpRequestToJson(this);
}
