// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userkey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserkeyResponse _$UserkeyResponseFromJson(Map<String, dynamic> json) =>
    UserkeyResponse(
      json['accessToken'] as String,
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserkeyResponseToJson(UserkeyResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'user': instance.user,
    };
