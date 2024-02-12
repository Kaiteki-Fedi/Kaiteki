// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstanceStatistics _$InstanceStatisticsFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'InstanceStatistics',
      json,
      ($checkedConvert) {
        final val = InstanceStatistics(
          userCount: $checkedConvert('user_count', (v) => v as int),
          statusCount: $checkedConvert('status_count', (v) => v as int),
          domainCount: $checkedConvert('domain_count', (v) => v as int),
        );
        return val;
      },
      fieldKeyMap: const {
        'userCount': 'user_count',
        'statusCount': 'status_count',
        'domainCount': 'domain_count'
      },
    );

Map<String, dynamic> _$InstanceStatisticsToJson(InstanceStatistics instance) =>
    <String, dynamic>{
      'user_count': instance.userCount,
      'status_count': instance.statusCount,
      'domain_count': instance.domainCount,
    };
