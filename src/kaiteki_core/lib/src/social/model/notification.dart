import 'post.dart';
import 'user.dart';

class Notification {
  final String id;
  final User? user;
  final Post? post;
  final NotificationType type;
  final bool? unread;
  final DateTime createdAt;

  const Notification({
    required this.id,
    required this.type,
    required this.createdAt,
    this.user,
    this.post,
    this.unread,
  });

  Notification copyWith({
    String? id,
    User? user,
    Post? post,
    NotificationType? type,
    bool? unread,
    DateTime? createdAt,
  }) {
    return Notification(
      id: id ?? this.id,
      user: user ?? this.user,
      post: post ?? this.post,
      type: type ?? this.type,
      unread: unread ?? this.unread,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class GroupedNotification implements Notification {
  final List<Notification> notifications;

  Notification get _latest => notifications.first;

  @override
  DateTime get createdAt => _latest.createdAt;

  @override
  bool get unread => notifications.any((e) => e.unread == true);

  @override
  Post? get post => _latest.post;

  @override
  NotificationType get type => _latest.type;

  @override
  User? get user => _latest.user;

  const GroupedNotification(this.notifications);

  @override
  String get id => _latest.id;

  @override
  Notification copyWith({
    String? id,
    User? user,
    Post? post,
    NotificationType? type,
    bool? unread,
    DateTime? createdAt,
  }) {
    throw UnsupportedError('Cannot copy a grouped notification');
  }
}

enum NotificationType {
  /// Someone has liked your post.
  liked,

  /// Someone has repeated your post.
  repeated,

  /// Someone has reacted to your post.
  reacted,

  /// Someone has followed you.
  followed,

  /// Someone has mentioned you in a post.
  mentioned,

  /// Someone wants to follow you.
  incomingFollowRequest,

  /// Someone has accepted your follow request.
  outgoingFollowRequestAccepted,

  /// Someone has invited you to a group.
  groupInvite,

  /// A poll that you participated in or created has ended.
  pollEnded,

  /// Someone else has quoted your post.
  quoted,

  /// Someone replied to your post.
  replied,

  /// A post that you have interacted with has been edited.
  updated,

  /// Someone sent a report.
  reported,

  /// Someone has joined the instance.
  signedUp,

  /// Someone has made a new post.
  newPost,

  /// Kaiteki received a notification type that it does not support.
  unsupported,

  /// Someone has moved to a new account.
  userMigrated,
}
