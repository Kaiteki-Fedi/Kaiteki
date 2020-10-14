// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonAccountField _$MastodonAccountFieldFromJson(Map<String, dynamic> json) {
  return MastodonAccountField(
    json['name'] as String,
    json['value'] as String,
  );
}

Map<String, dynamic> _$MastodonAccountFieldToJson(
        MastodonAccountField instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };
