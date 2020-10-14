// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonMediaAttachment _$MastodonMediaAttachmentFromJson(
    Map<String, dynamic> json) {
  return MastodonMediaAttachment(
    description: json['description'] as String,
    id: json['id'] as String,
    previewUrl: json['preview_url'] as String,
    remoteUrl: json['remote_url'] as String,
    textUrl: json['text_url'] as String,
    type: json['type'] as String,
    url: json['url'] as String,
  );
}

Map<String, dynamic> _$MastodonMediaAttachmentToJson(
        MastodonMediaAttachment instance) =>
    <String, dynamic>{
      'description': instance.description,
      'id': instance.id,
      'preview_url': instance.previewUrl,
      'remote_url': instance.remoteUrl,
      'text_url': instance.textUrl,
      'type': instance.type,
      'url': instance.url,
    };
