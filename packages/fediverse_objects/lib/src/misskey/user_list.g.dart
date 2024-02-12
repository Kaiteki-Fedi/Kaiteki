// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserList _$UserListFromJson(Map<String, dynamic> json) => $checkedCreate(
      'UserList',
      json,
      ($checkedConvert) {
        final val = UserList(
          id: $checkedConvert('id', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          name: $checkedConvert('name', (v) => v as String),
          userIds: $checkedConvert('userIds',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$UserListToJson(UserList instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'name': instance.name,
      'userIds': instance.userIds,
    };
