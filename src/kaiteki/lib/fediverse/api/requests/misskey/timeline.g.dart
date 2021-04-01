// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyTimelineRequest _$MisskeyTimelineRequestFromJson(
    Map<String, dynamic> json) {
  return MisskeyTimelineRequest(
    excludeNsfw: json['excludeNsfw'] as bool?,
    fileType: (json['fileType'] as List<dynamic>?)?.map((e) => e as String),
    limit: json['limit'] as int,
    sinceId: json['sinceId'] as String?,
    untilId: json['untilId'] as String?,
    sinceDate: json['sinceDate'] as int?,
    untilDate: json['untilDate'] as int?,
    includeMyRenotes: json['includeMyRenotes'] as bool,
    includeLocalRenotes: json['includeLocalRenotes'] as bool,
    withFiles: json['withFiles'] as bool?,
  );
}

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
