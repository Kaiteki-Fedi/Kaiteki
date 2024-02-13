import 'package:json_annotation/json_annotation.dart';

import 'account.dart';

part 'report.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Report {
  final String id;

  final bool actionTaken;

  final DateTime? actionTakenAt;

  // NULL(pleroma)
  @JsonKey(unknownEnumValue: null)
  final ReportCategory? category;

  // NULL(pleroma)
  final bool? forwarded;

  // NULL(pleroma)
  final DateTime? createdAt;

  // NULL(pleroma)
  final List<String>? statusIds;

  // NULL(pleroma)
  final List<int>? ruleIds;

  // NULL(pleroma)
  final Account? targetAccount;

  // NULL(pleroma)
  final String? comment;

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

  const Report({
    required this.id,
    required this.actionTaken,
    required this.actionTakenAt,
    required this.category,
    required this.forwarded,
    required this.createdAt,
    required this.statusIds,
    required this.ruleIds,
    required this.targetAccount,
    this.comment,
  });

  Map<String, dynamic> toJson() => _$ReportToJson(this);
}

enum ReportCategory { spam, violation, other }
