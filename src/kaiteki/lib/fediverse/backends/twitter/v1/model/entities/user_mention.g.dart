// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_mention.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMention _$UserMentionFromJson(Map<String, dynamic> json) => UserMention(
      id: json['id'] as int,
      idStr: json['id_str'] as String,
      name: json['name'] as String,
      screenName: json['screen_name'] as String,
      indices: (json['indices'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$UserMentionToJson(UserMention instance) =>
    <String, dynamic>{
      'indices': instance.indices,
      'id': instance.id,
      'id_str': instance.idStr,
      'name': instance.name,
      'screen_name': instance.screenName,
    };
