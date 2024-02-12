// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Clip _$ClipFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Clip',
      json,
      ($checkedConvert) {
        final val = Clip(
          id: $checkedConvert('id', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          userId: $checkedConvert('userId', (v) => v as String),
          user: $checkedConvert(
              'user', (v) => User.fromJson(v as Map<String, dynamic>)),
          name: $checkedConvert('name', (v) => v as String),
          description: $checkedConvert('description', (v) => v as String?),
          isPublic: $checkedConvert('isPublic', (v) => v as bool),
        );
        return val;
      },
    );

Map<String, dynamic> _$ClipToJson(Clip instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'userId': instance.userId,
      'user': instance.user,
      'name': instance.name,
      'description': instance.description,
      'isPublic': instance.isPublic,
    };
