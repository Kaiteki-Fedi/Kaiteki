// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instances.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstanceData _$InstanceDataFromJson(Map<String, dynamic> json) => InstanceData(
      type: $enumDecode(_$ApiTypeEnumMap, json['type']),
      host: json['host'] as String,
      name: json['name'] as String?,
      shortDescription: json['shortDescription'] as String?,
      favicon: json['favicon'] as String?,
      rules:
          (json['rules'] as List<dynamic>?)?.map((e) => e as String).toList(),
      rulesUrl: json['rulesUrl'] as String?,
      usesCovenant: json['usesCovenant'] as bool? ?? false,
      usesMastodonCovenant: json['usesMastodonCovenant'] as bool? ?? false,
    );

Map<String, dynamic> _$InstanceDataToJson(InstanceData instance) =>
    <String, dynamic>{
      'type': _$ApiTypeEnumMap[instance.type]!,
      'host': instance.host,
      'name': instance.name,
      'shortDescription': instance.shortDescription,
      'favicon': instance.favicon,
      'rules': instance.rules,
      'rulesUrl': instance.rulesUrl,
      'usesCovenant': instance.usesCovenant,
      'usesMastodonCovenant': instance.usesMastodonCovenant,
    };

const _$ApiTypeEnumMap = {
  ApiType.mastodon: 'mastodon',
  ApiType.pleroma: 'pleroma',
  ApiType.misskey: 'misskey',
  ApiType.twitter: 'twitter',
  ApiType.twitterV1: 'twitterV1',
  ApiType.tumblr: 'tumblr',
};
