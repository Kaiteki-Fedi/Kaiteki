// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attachment _$AttachmentFromJson(Map<String, dynamic> json) {
  return Attachment(
    id: json['id'] as String,
    type: json['type'] as String,
    url: json['url'] as String,
    previewUrl: json['preview_url'] as String,
    remoteUrl: json['remote_url'] as String?,
    textUrl: json['text_url'] as String?,
    description: json['description'] as String?,
    blurhash: json['blurhash'] as String?,
  );
}

Map<String, dynamic> _$AttachmentToJson(Attachment instance) =>
    <String, dynamic>{
      'description': instance.description,
      'id': instance.id,
      'preview_url': instance.previewUrl,
      'remote_url': instance.remoteUrl,
      'text_url': instance.textUrl,
      'type': instance.type,
      'url': instance.url,
      'blurhash': instance.blurhash,
    };
