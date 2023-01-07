// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Media _$MediaFromJson(Map<String, dynamic> json) => Media(
      displayUrl: json['display_url'] as String,
      expandedUrl: json['expanded_url'] as String,
      id: json['id'] as int,
      idStr: json['id_str'] as String,
      mediaUrl: json['media_url'] as String,
      mediaUrlHttps: json['media_url_https'] as String,
      type: json['type'] as String,
      indices: (json['indices'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$MediaToJson(Media instance) => <String, dynamic>{
      'indices': instance.indices,
      'display_url': instance.displayUrl,
      'expanded_url': instance.expandedUrl,
      'id': instance.id,
      'id_str': instance.idStr,
      'media_url': instance.mediaUrl,
      'media_url_https': instance.mediaUrlHttps,
      'type': instance.type,
    };
