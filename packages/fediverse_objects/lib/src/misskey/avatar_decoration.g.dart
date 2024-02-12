// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_decoration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvatarDecoration _$AvatarDecorationFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AvatarDecoration',
      json,
      ($checkedConvert) {
        final val = AvatarDecoration(
          id: $checkedConvert('id', (v) => v as String),
          url: $checkedConvert('url', (v) => Uri.parse(v as String)),
          angle: $checkedConvert('angle', (v) => (v as num?)?.toDouble()),
          flipH: $checkedConvert('flipH', (v) => v as bool?),
        );
        return val;
      },
    );

Map<String, dynamic> _$AvatarDecorationToJson(AvatarDecoration instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url.toString(),
      'angle': instance.angle,
      'flipH': instance.flipH,
    };
