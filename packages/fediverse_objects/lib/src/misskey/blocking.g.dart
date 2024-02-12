// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Blocking _$BlockingFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Blocking',
      json,
      ($checkedConvert) {
        final val = Blocking(
          id: $checkedConvert('id', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          blockeeId: $checkedConvert('blockeeId', (v) => v as String),
          blockee: $checkedConvert('blockee', (v) => v),
        );
        return val;
      },
    );

Map<String, dynamic> _$BlockingToJson(Blocking instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'blockeeId': instance.blockeeId,
      'blockee': instance.blockee,
    };
