import 'package:fediverse_objects/mastodon.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PleromaReport {
  final String id;
  final PleromaReportState state;
  final Account account;
  final Account actor;
  final String content;
  final DateTime createdAt;
  final List<Status> statuses;

  PleromaReport({
    required this.id,
    required this.state,
    required this.account,
    required this.actor,
    required this.content,
    required this.createdAt,
    required this.statuses,
  });

  factory PleromaReport.fromJson(Map<String, dynamic> json) =>
      _$PleromaReportFromJson(json);

  Map<String, dynamic> toJson() => _$PleromaReportToJson(this);
}

enum PleromaReportState { open, closed, resolved }
