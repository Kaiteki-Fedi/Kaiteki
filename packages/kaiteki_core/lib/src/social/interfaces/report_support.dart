import 'package:kaiteki_core/social.dart';

abstract class ReportSupport {
  ReportCapabilities get capabilities;

  Future<Report?> submitReport({
    required String userId,
    required String? comment,
    List<String> postIds = const [],
    bool forwardToRemoteInstance = false,
  });
}

abstract class ReportCapabilities extends AdapterCapabilities {
  bool get canForwardReportsToRemoteInstances;
  bool get canIncludePosts;
  int? get reportCommentLengthLimit;

  const ReportCapabilities();
}
