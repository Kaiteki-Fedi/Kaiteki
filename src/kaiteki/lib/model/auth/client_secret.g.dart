// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_secret.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientSecret _$ClientSecretFromJson(Map<String, dynamic> json) {
  return ClientSecret(
    json['instance'] as String,
    json['id'] as String,
    json['secret'] as String,
    apiType: _$enumDecodeNullable(_$ApiTypeEnumMap, json['type']),
  );
}

Map<String, dynamic> _$ClientSecretToJson(ClientSecret instance) =>
    <String, dynamic>{
      'id': instance.clientId,
      'secret': instance.clientSecret,
      'instance': instance.instance,
      'type': _$ApiTypeEnumMap[instance.apiType],
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

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$ApiTypeEnumMap = {
  ApiType.Mastodon: 'Mastodon',
  ApiType.Pleroma: 'Pleroma',
  ApiType.Misskey: 'Misskey',
};
