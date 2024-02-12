// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

List _$ListFromJson(Map<String, dynamic> json) => $checkedCreate(
      'List',
      json,
      ($checkedConvert) {
        final val = List(
          id: $checkedConvert('id', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String),
          repliesPolicy: $checkedConvert('replies_policy',
              (v) => $enumDecodeNullable(_$RepliesPolicyEnumMap, v)),
        );
        return val;
      },
      fieldKeyMap: const {'repliesPolicy': 'replies_policy'},
    );

Map<String, dynamic> _$ListToJson(List instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'replies_policy': _$RepliesPolicyEnumMap[instance.repliesPolicy],
    };

const _$RepliesPolicyEnumMap = {
  RepliesPolicy.followed: 'followed',
  RepliesPolicy.list: 'list',
  RepliesPolicy.none: 'none',
};
