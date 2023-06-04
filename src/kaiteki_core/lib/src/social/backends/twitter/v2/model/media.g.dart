// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Media _$MediaFromJson(Map<String, dynamic> json) => Media(
      mediaKey: json['media_key'] as String,
      type: $enumDecode(_$MediaTypeEnumMap, json['type']),
      url: json['url'] as String?,
      height: json['height'] as int?,
      durationMs: json['duration_ms'] as int?,
      previewImageUrl: json['preview_image_url'] as String?,
      width: json['width'] as int?,
      altText: json['alt_text'] as String?,
    );

const _$MediaTypeEnumMap = {
  MediaType.video: 'video',
  MediaType.animatedGif: 'animated_gif',
  MediaType.photo: 'photo',
};
