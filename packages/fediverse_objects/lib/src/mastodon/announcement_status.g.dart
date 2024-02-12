// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnouncementStatus _$AnnouncementStatusFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AnnouncementStatus',
      json,
      ($checkedConvert) {
        final val = AnnouncementStatus(
          id: $checkedConvert('id', (v) => v as String),
          url: $checkedConvert('url', (v) => Uri.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$AnnouncementStatusToJson(AnnouncementStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url.toString(),
    };
