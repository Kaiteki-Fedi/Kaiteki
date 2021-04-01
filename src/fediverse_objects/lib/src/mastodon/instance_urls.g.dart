// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_urls.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonInstanceUrls _$MastodonInstanceUrlsFromJson(Map<String, dynamic> json) {
  return MastodonInstanceUrls(
    streamingApi: json['streaming_api'] as String,
  );
}

Map<String, dynamic> _$MastodonInstanceUrlsToJson(
        MastodonInstanceUrls instance) =>
    <String, dynamic>{
      'streaming_api': instance.streamingApi,
    };
