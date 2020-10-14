// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return LoginResponse(
    json['access_token'] as String,
    json['expires_in'] as int,
    json['me'] as String,
    json['refresh_token'] as String,
    json['scope'] as String,
    json['token_type'] as String,
    json['error'] as String,
    json['mfa_token'] as String,
  );
}

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'expires_in': instance.expiresIn,
      'me': instance.me,
      'refresh_token': instance.refreshToken,
      'scope': instance.scope,
      'token_type': instance.tokenType,
      'error': instance.error,
      'mfa_token': instance.mfaToken,
    };
