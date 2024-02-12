// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ad _$AdFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Ad',
      json,
      ($checkedConvert) {
        final val = Ad(
          place: $checkedConvert('place', (v) => v as String),
          url: $checkedConvert('url', (v) => v as String),
          imageUrl: $checkedConvert('imageUrl', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$AdToJson(Ad instance) => <String, dynamic>{
      'place': instance.place,
      'url': instance.url,
      'imageUrl': instance.imageUrl,
    };
