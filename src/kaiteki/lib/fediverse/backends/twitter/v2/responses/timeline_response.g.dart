// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimelineResponse _$TimelineResponseFromJson(Map<String, dynamic> json) =>
    TimelineResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => Tweet.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: TimelineResponseMeta.fromJson(json['meta'] as Map<String, dynamic>),
      includes: json['includes'] == null
          ? null
          : ResponseIncludes.fromJson(json['includes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TimelineResponseToJson(TimelineResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'includes': instance.includes,
      'meta': instance.meta,
    };

TimelineResponseMeta _$TimelineResponseMetaFromJson(
        Map<String, dynamic> json) =>
    TimelineResponseMeta(
      newestId: json['newest_id'] as String?,
      oldestId: json['oldest_id'] as String?,
      nextToken: json['next_token'] as String?,
      previousToken: json['previous_token'] as String?,
      resultCount: json['result_count'] as int,
    );

Map<String, dynamic> _$TimelineResponseMetaToJson(
        TimelineResponseMeta instance) =>
    <String, dynamic>{
      'newest_id': instance.newestId,
      'oldest_id': instance.oldestId,
      'next_token': instance.nextToken,
      'previous_token': instance.previousToken,
      'result_count': instance.resultCount,
    };
