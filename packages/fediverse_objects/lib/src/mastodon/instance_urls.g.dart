// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_urls.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstanceUrls _$InstanceUrlsFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'InstanceUrls',
      json,
      ($checkedConvert) {
        final val = InstanceUrls(
          streamingApi: $checkedConvert('streaming_api', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'streamingApi': 'streaming_api'},
    );

Map<String, dynamic> _$InstanceUrlsToJson(InstanceUrls instance) =>
    <String, dynamic>{
      'streaming_api': instance.streamingApi,
    };
