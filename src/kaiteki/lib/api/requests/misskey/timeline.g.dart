// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$MisskeyTimelineRequestToJson(
        MisskeyTimelineRequest instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'sinceId': instance.sinceId,
      'untilId': instance.untilId,
      'sinceDate': instance.sinceDate,
      'untilDate': instance.untilDate,
      'includeMyRenotes': instance.includeMyRenotes,
      'includeLocalRenotes': instance.includeLocalRenotes,
      'withFiles': instance.withFiles,
      'excludeNsfw': instance.excludeNsfw,
      'fileType': instance.fileType?.toList(),
    };
