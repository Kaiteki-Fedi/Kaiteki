// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_upload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaUpload _$MediaUploadFromJson(Map<String, dynamic> json) => MediaUpload(
      mediaId: json['media_id'] as int,
      mediaIdString: json['media_id_string'] as String,
      size: json['size'] as int,
      expiresAfterSecs: json['expires_after_secs'] as int,
      mediaKey: json['media_key'] as String,
      image: MediaUploadImage.fromJson(json['image'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MediaUploadToJson(MediaUpload instance) =>
    <String, dynamic>{
      'media_id': instance.mediaId,
      'media_id_string': instance.mediaIdString,
      'size': instance.size,
      'expires_after_secs': instance.expiresAfterSecs,
      'media_key': instance.mediaKey,
      'image': instance.image,
    };

MediaUploadImage _$MediaUploadImageFromJson(Map<String, dynamic> json) =>
    MediaUploadImage(
      imageType: json['image_type'] as String,
      w: json['w'] as int,
      h: json['h'] as int,
    );

Map<String, dynamic> _$MediaUploadImageToJson(MediaUploadImage instance) =>
    <String, dynamic>{
      'image_type': instance.imageType,
      'w': instance.w,
      'h': instance.h,
    };
