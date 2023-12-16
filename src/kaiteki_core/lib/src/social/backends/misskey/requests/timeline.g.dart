// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$MisskeyTimelineRequestToJson(
    MisskeyTimelineRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('limit', instance.limit);
  writeNotNull('sinceId', instance.sinceId);
  writeNotNull('untilId', instance.untilId);
  writeNotNull('sinceDate', instance.sinceDate);
  writeNotNull('untilDate', instance.untilDate);
  writeNotNull('includeMyRenotes', instance.includeMyRenotes);
  writeNotNull('includeLocalRenotes', instance.includeLocalRenotes);
  writeNotNull('withFiles', instance.withFiles);
  writeNotNull('excludeNsfw', instance.excludeNsfw);
  return val;
}
