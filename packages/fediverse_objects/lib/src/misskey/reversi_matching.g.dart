// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reversi_matching.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReversiMatching _$ReversiMatchingFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ReversiMatching',
      json,
      ($checkedConvert) {
        final val = ReversiMatching(
          id: $checkedConvert('id', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          parentId: $checkedConvert('parentId', (v) => v as String),
          parent: $checkedConvert(
              'parent',
              (v) =>
                  v == null ? null : User.fromJson(v as Map<String, dynamic>)),
          childId: $checkedConvert('childId', (v) => v as String),
          child: $checkedConvert(
              'child', (v) => User.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$ReversiMatchingToJson(ReversiMatching instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'parentId': instance.parentId,
      'parent': instance.parent,
      'childId': instance.childId,
      'child': instance.child,
    };
