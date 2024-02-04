// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emojis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmojisResponse _$EmojisResponseFromJson(Map<String, dynamic> json) =>
    EmojisResponse(
      (json['emojis'] as List<dynamic>)
          .map((e) => Emoji.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EmojisResponseToJson(EmojisResponse instance) =>
    <String, dynamic>{
      'emojis': instance.emojis,
    };
