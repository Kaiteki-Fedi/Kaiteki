// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Muting _$MutingFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Muting',
      json,
      ($checkedConvert) {
        final val = Muting(
          id: $checkedConvert('id', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          expiresAt: $checkedConvert('expiresAt',
              (v) => v == null ? null : DateTime.parse(v as String)),
          muteeId: $checkedConvert('muteeId', (v) => v as String),
          mutee: $checkedConvert('mutee', (v) => v),
        );
        return val;
      },
    );

Map<String, dynamic> _$MutingToJson(Muting instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'muteeId': instance.muteeId,
      'mutee': instance.mutee,
    };
