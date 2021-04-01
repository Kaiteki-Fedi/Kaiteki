import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';

class Notification {
  final User user;
  final Post post;

  const Notification({required this.user, required this.post,});
}
