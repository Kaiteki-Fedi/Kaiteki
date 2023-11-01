// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerateSessionResponse _$GenerateSessionResponseFromJson(
        Map<String, dynamic> json) =>
    GenerateSessionResponse(
      json['token'] as String,
      json['url'] as String,
    );

Map<String, dynamic> _$GenerateSessionResponseToJson(
        GenerateSessionResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'url': instance.url,
    };
