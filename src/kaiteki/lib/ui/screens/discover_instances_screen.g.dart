// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_instances_screen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstanceData _$InstanceDataFromJson(Map<String, dynamic> json) {
  return InstanceData(
    type: _$enumDecode(_$ApiTypeEnumMap, json['type']),
    name: json['name'] as String,
    shortDescription: json['shortDescription'] as String?,
    favicon: json['favicon'] as String?,
    rules: (json['rules'] as List<dynamic>?)?.map((e) => e as String).toList(),
    rulesUrl: json['rulesUrl'] as String?,
    usesConvenant: json['usesConvenant'] as bool? ?? false,
  );
}

Map<String, dynamic> _$InstanceDataToJson(InstanceData instance) =>
    <String, dynamic>{
      'type': _$ApiTypeEnumMap[instance.type],
      'name': instance.name,
      'shortDescription': instance.shortDescription,
      'favicon': instance.favicon,
      'rules': instance.rules,
      'rulesUrl': instance.rulesUrl,
      'usesConvenant': instance.usesConvenant,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$ApiTypeEnumMap = {
  ApiType.mastodon: 'mastodon',
  ApiType.pleroma: 'pleroma',
  ApiType.misskey: 'misskey',
};
