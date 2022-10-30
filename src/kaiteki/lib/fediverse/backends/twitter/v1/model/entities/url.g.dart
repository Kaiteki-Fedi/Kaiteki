// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'url.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Url _$UrlFromJson(Map<String, dynamic> json) => Url(
      displayUrl: json['display_url'] as String,
      expandedUrl: json['expanded_url'] as String,
      url: json['url'] as String,
      indices: (json['indices'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$UrlToJson(Url instance) => <String, dynamic>{
      'indices': instance.indices,
      'display_url': instance.displayUrl,
      'expanded_url': instance.expandedUrl,
      'url': instance.url,
    };
