// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyCheckSessionResponse _$MisskeyCheckSessionResponseFromJson(
        Map<String, dynamic> json) =>
    MisskeyCheckSessionResponse(
      token: json['token'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MisskeyCheckSessionResponseToJson(
        MisskeyCheckSessionResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'user': instance.user,
    };
