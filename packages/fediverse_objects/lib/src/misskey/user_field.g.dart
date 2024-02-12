// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserField _$UserFieldFromJson(Map<String, dynamic> json) => $checkedCreate(
      'UserField',
      json,
      ($checkedConvert) {
        final val = UserField(
          name: $checkedConvert('name', (v) => v as String),
          value: $checkedConvert('value', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$UserFieldToJson(UserField instance) => <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };
