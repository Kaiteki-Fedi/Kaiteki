// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_secret.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientSecret _$ClientSecretFromJson(Map<String, dynamic> json) => ClientSecret(
      json['instance'] as String,
      json['id'] as String,
      json['secret'] as String,
      apiType: $enumDecodeNullable(_$ApiTypeEnumMap, json['type'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
    );

Map<String, dynamic> _$ClientSecretToJson(ClientSecret instance) =>
    <String, dynamic>{
      'id': instance.clientId,
      'secret': instance.clientSecret,
      'instance': instance.instance,
      'type': _$ApiTypeEnumMap[instance.apiType],
    };

const _$ApiTypeEnumMap = {
  ApiType.mastodon: 'mastodon',
  ApiType.pleroma: 'pleroma',
  ApiType.misskey: 'misskey',
};
