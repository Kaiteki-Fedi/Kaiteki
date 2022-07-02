import 'package:kaiteki/fediverse/capabilities.dart';
import 'package:kaiteki/fediverse/model/report.dart';

abstract class ReportSupport {
  ReportSupportCapabilities get capabilities;
  Future<void> report(String userId, String comment, {List<String>? statusIds});
  Future<List<Report>> getReports() => throw UnimplementedError();
}

abstract class ReportSupportCapabilities extends AdapterCapabilities {
  bool get supportsListingReports;
  int get maxReportCommentLength;
  const ReportSupportCapabilities();
}
