// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Avatar _$AvatarFromJson(Map<String, dynamic> json) => Avatar(
      width: json['width'] as int,
      height: json['height'] as int,
      url: Uri.parse(json['url'] as String),
    );

Map<String, dynamic> _$AvatarToJson(Avatar instance) => <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'url': instance.url.toString(),
    };
