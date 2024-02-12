// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Source _$SourceFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Source',
      json,
      ($checkedConvert) {
        final val = Source(
          note: $checkedConvert('note', (v) => v as String),
          fields: $checkedConvert(
              'fields',
              (v) => (v as List<dynamic>)
                  .map((e) => Field.fromJson(e as Map<String, dynamic>))
                  .toList()),
          privacy: $checkedConvert('privacy', (v) => v as String?),
          sensitive: $checkedConvert('sensitive', (v) => v as bool?),
          language: $checkedConvert('language', (v) => v as String?),
          followRequestsCount:
              $checkedConvert('follow_requests_count', (v) => v as int?),
          pleroma: $checkedConvert(
              'pleroma',
              (v) => v == null
                  ? null
                  : PleromaSource.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {'followRequestsCount': 'follow_requests_count'},
    );

Map<String, dynamic> _$SourceToJson(Source instance) => <String, dynamic>{
      'note': instance.note,
      'fields': instance.fields,
      'privacy': instance.privacy,
      'sensitive': instance.sensitive,
      'language': instance.language,
      'follow_requests_count': instance.followRequestsCount,
      'pleroma': instance.pleroma,
    };
