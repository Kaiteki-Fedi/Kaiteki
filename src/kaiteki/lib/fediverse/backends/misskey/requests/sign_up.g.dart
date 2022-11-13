// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeySignUpRequest _$MisskeySignUpRequestFromJson(
        Map<String, dynamic> json) =>
    MisskeySignUpRequest(
      username: json['username'] as String,
      password: json['password'] as String,
      token: json['token'] as String,
      invitationCode: json['invitationCode'] as String?,
      hcaptchaResponse: json['hcaptchaResponse'] as String?,
      recaptchaResponse: json['recaptchaResponse'] as String?,
    );

Map<String, dynamic> _$MisskeySignUpRequestToJson(
        MisskeySignUpRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'token': instance.token,
      'invitationCode': instance.invitationCode,
      'hcaptchaResponse': instance.hcaptchaResponse,
      'recaptchaResponse': instance.recaptchaResponse,
    };
