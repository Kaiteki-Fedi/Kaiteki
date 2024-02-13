import 'user.dart';

class Report {
  /// Whether the moderation team has processed this report.
  final bool resolved;
  final String id;
  final DateTime? submittedAt;
  final String? reportingUserId;
  final User? reportingUser;
  final String? reportedUserId;
  final User? reportedUser;
  final String? comment;

  const Report({
    required this.resolved,
    required this.id,
    this.submittedAt,
    this.reportingUserId,
    this.reportingUser,
    this.comment,
    this.reportedUserId,
    this.reportedUser,
  });
}
