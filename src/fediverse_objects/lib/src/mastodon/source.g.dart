// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonSource _$MastodonSourceFromJson(Map<String, dynamic> json) {
  return MastodonSource(
    note: json['note'] as String,
    fields: (json['fields'] as List<dynamic>)
        .map((e) => MastodonField.fromJson(e as Map<String, dynamic>)),
    privacy: json['privacy'] as String?,
    sensitive: json['sensitive'] as bool?,
    language: json['language'] as String?,
    followRequestsCount: json['follow_requests_count'] as int?,
  );
}

Map<String, dynamic> _$MastodonSourceToJson(MastodonSource instance) =>
    <String, dynamic>{
      'note': instance.note,
      'fields': instance.fields.toList(),
      'privacy': instance.privacy,
      'sensitive': instance.sensitive,
      'language': instance.language,
      'follow_requests_count': instance.followRequestsCount,
    };
