/// Represents an announcement published by the instance.
class Announcement {
  final String id;
  final String? title;
  final String content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Whether to show the announcement to the user at sign-in.
  final bool? important;

  /// Whether the announcement is unread.
  final bool? isUnread;

  const Announcement({
    required this.id,
    required this.content,
    this.createdAt,
    this.updatedAt,
    required this.important,
    required this.isUnread,
    this.title,
  });
}
