// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Report',
      json,
      ($checkedConvert) {
        final val = Report(
          id: $checkedConvert('id', (v) => v as String),
          actionTaken: $checkedConvert('action_taken', (v) => v as bool),
          actionTakenAt: $checkedConvert('action_taken_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          category: $checkedConvert('category',
              (v) => $enumDecodeNullable(_$ReportCategoryEnumMap, v)),
          forwarded: $checkedConvert('forwarded', (v) => v as bool?),
          createdAt: $checkedConvert('created_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          statusIds: $checkedConvert('status_ids',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
          ruleIds: $checkedConvert('rule_ids',
              (v) => (v as List<dynamic>?)?.map((e) => e as int).toList()),
          targetAccount: $checkedConvert(
              'target_account',
              (v) => v == null
                  ? null
                  : Account.fromJson(v as Map<String, dynamic>)),
          comment: $checkedConvert('comment', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'actionTaken': 'action_taken',
        'actionTakenAt': 'action_taken_at',
        'createdAt': 'created_at',
        'statusIds': 'status_ids',
        'ruleIds': 'rule_ids',
        'targetAccount': 'target_account'
      },
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'id': instance.id,
      'action_taken': instance.actionTaken,
      'action_taken_at': instance.actionTakenAt?.toIso8601String(),
      'category': _$ReportCategoryEnumMap[instance.category],
      'forwarded': instance.forwarded,
      'created_at': instance.createdAt?.toIso8601String(),
      'status_ids': instance.statusIds,
      'rule_ids': instance.ruleIds,
      'target_account': instance.targetAccount,
      'comment': instance.comment,
    };

const _$ReportCategoryEnumMap = {
  ReportCategory.spam: 'spam',
  ReportCategory.violation: 'violation',
  ReportCategory.other: 'other',
};
