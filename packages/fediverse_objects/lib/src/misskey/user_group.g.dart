// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserGroup _$UserGroupFromJson(Map<String, dynamic> json) => $checkedCreate(
      'UserGroup',
      json,
      ($checkedConvert) {
        final val = UserGroup(
          id: $checkedConvert('id', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          name: $checkedConvert('name', (v) => v as String),
          ownerId: $checkedConvert('ownerId', (v) => v as String),
          userIds: $checkedConvert('userIds',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$UserGroupToJson(UserGroup instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'name': instance.name,
      'ownerId': instance.ownerId,
      'userIds': instance.userIds,
    };
