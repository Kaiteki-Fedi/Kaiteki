import 'package:kaiteki/fediverse/capabilities.dart';
import 'package:kaiteki/fediverse/interfaces/report_support.dart';
import 'package:kaiteki/fediverse/model/formatting.dart';

class MastodonCapabilities extends AdapterCapabilities
    implements ReportSupportCapabilities {
  const MastodonCapabilities();

  @override
  bool get supportsScopes => true;

  @override
  bool get supportsSubjects => true;

  @override
  List<Formatting> get supportedFormattings {
    return List.unmodifiable([Formatting.plainText]);
  }

  @override
  int get maxReportCommentLength => 1000;

  @override
  bool get supportsListingReports => false;
}
