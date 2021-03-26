// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonTag _$MastodonTagFromJson(Map<String, dynamic> json) {
  return MastodonTag(
    name: json['name'] as String,
    url: json['url'] as String,
  );
}

Map<String, dynamic> _$MastodonTagToJson(MastodonTag instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
    };
