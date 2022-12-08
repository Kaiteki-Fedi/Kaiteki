import 'package:kaiteki/fediverse/model/post/post.dart';
import 'package:kaiteki/fediverse/model/user/user.dart';

class Notification {
  final User? user;
  final Post? post;
  final NotificationType type;
  final bool? unread;
  final DateTime createdAt;

  const Notification({
    required this.type,
    required this.createdAt,
    this.user,
    this.post,
    this.unread,
  });
}

enum NotificationType {
  liked,
  repeated,
  reacted,
  followed,
  mentioned,
  followRequest,
  groupInvite,
  pollEnded,
  quoted,
  replied
}
