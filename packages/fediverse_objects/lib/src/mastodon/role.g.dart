// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Role _$RoleFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Role',
      json,
      ($checkedConvert) {
        final val = Role(
          id: $checkedConvert('id', (v) => v as int),
          name: $checkedConvert('name', (v) => v as String),
          color: $checkedConvert('color', (v) => v as String),
          permissions: $checkedConvert('permissions', (v) => v as int),
          highlighted: $checkedConvert('highlighted', (v) => v as bool),
        );
        return val;
      },
    );

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
      'permissions': instance.permissions,
      'highlighted': instance.highlighted,
    };
