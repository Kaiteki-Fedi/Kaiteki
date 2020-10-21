// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyPageVariable _$MisskeyPageVariableFromJson(Map<String, dynamic> json) {
  return MisskeyPageVariable(
    id: json['id'] as String,
    args: (json['args'] as List)?.map((e) => e == null
        ? null
        : MisskeyPageVariableArgument.fromJson(e as Map<String, dynamic>)),
    name: json['name'] as String,
    type: json['type'] as String,
    value: json['value'],
  );
}

Map<String, dynamic> _$MisskeyPageVariableToJson(
        MisskeyPageVariable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'args': instance.args?.toList(),
      'name': instance.name,
      'type': instance.type,
      'value': instance.value,
    };
