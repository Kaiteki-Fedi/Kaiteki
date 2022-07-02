import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/fediverse/backends/pleroma/model/report.dart';

part 'report.g.dart';

@JsonSerializable()
class PleromaReportResponse {
  final int total;
  final List<PleromaReport> reports;

  PleromaReportResponse({
    required this.total,
    required this.reports,
  });

  factory PleromaReportResponse.fromJson(Map<String, dynamic> json) =>
      _$PleromaReportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PleromaReportResponseToJson(this);
}
