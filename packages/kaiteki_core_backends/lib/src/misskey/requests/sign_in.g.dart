// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeySignInRequest _$MisskeySignInRequestFromJson(
        Map<String, dynamic> json) =>
    MisskeySignInRequest(
      username: json['username'] as String,
      password: json['password'] as String,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$MisskeySignInRequestToJson(
        MisskeySignInRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'token': instance.token,
    };
