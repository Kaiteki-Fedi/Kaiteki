// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$MisskeyTimelineRequestToJson(
    MisskeyTimelineRequest instance) {
  final val = <String, dynamic>{
    'limit': instance.limit,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('sinceId', instance.sinceId);
  writeNotNull('untilId', instance.untilId);
  writeNotNull('sinceDate', instance.sinceDate);
  writeNotNull('untilDate', instance.untilDate);
  val['includeMyRenotes'] = instance.includeMyRenotes;
  val['includeLocalRenotes'] = instance.includeLocalRenotes;
  writeNotNull('withFiles', instance.withFiles);
  writeNotNull('excludeNsfw', instance.excludeNsfw);
  writeNotNull('fileType', instance.fileType?.toList());
  return val;
}
