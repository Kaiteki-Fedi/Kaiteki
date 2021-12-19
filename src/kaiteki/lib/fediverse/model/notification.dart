import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';

class Notification {
  final User? user;
  final Post? post;
  final NotificationType type;

  const Notification({
    required this.type,
    this.user,
    this.post,
  });
}

enum NotificationType { liked, repeated, reacted, followed, mentioned }
