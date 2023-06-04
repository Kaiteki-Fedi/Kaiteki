// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckSessionResponse _$CheckSessionResponseFromJson(
        Map<String, dynamic> json) =>
    CheckSessionResponse(
      token: json['token'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CheckSessionResponseToJson(
        CheckSessionResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'user': instance.user,
    };
