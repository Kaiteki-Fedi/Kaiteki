class Report {
  final String userId;
  final String comment;
  final ReportState state;
  final DateTime createdAt;

  const Report({
    required this.createdAt,
    required this.userId,
    required this.comment,
    this.state = ReportState.open,
  });
}

enum ReportState { open, closed, resolved }
