// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenResponse _$TokenResponseFromJson(Map<String, dynamic> json) =>
    TokenResponse(
      tokenType: json['token_type'] as String,
      expiresIn: json['expires_in'] as int,
      accessToken: json['access_token'] as String,
      scope: json['scope'] as String,
      refreshToken: json['refresh_token'] as String,
    );

Map<String, dynamic> _$TokenResponseToJson(TokenResponse instance) =>
    <String, dynamic>{
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
      'access_token': instance.accessToken,
      'scope': instance.scope,
      'refresh_token': instance.refreshToken,
    };
