// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstanceStatistics _$InstanceStatisticsFromJson(Map<String, dynamic> json) {
  return InstanceStatistics(
    userCount: json['user_count'] as int,
    statusCount: json['status_count'] as int,
    domainCount: json['domain_count'] as int,
  );
}

Map<String, dynamic> _$InstanceStatisticsToJson(InstanceStatistics instance) =>
    <String, dynamic>{
      'user_count': instance.userCount,
      'status_count': instance.statusCount,
      'domain_count': instance.domainCount,
    };
