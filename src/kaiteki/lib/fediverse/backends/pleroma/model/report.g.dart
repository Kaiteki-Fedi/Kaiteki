// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaReport _$PleromaReportFromJson(Map<String, dynamic> json) =>
    PleromaReport(
      id: json['id'] as String,
      state: $enumDecode(_$PleromaReportStateEnumMap, json['state']),
      account: Account.fromJson(json['account'] as Map<String, dynamic>),
      actor: Account.fromJson(json['actor'] as Map<String, dynamic>),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      statuses: (json['statuses'] as List<dynamic>)
          .map((e) => Status.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PleromaReportToJson(PleromaReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'state': _$PleromaReportStateEnumMap[instance.state],
      'account': instance.account,
      'actor': instance.actor,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'statuses': instance.statuses,
    };

const _$PleromaReportStateEnumMap = {
  PleromaReportState.open: 'open',
  PleromaReportState.closed: 'closed',
  PleromaReportState.resolved: 'resolved',
};
