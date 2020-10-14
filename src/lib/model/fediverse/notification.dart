import 'package:kaiteki/model/fediverse/post.dart';
import 'package:kaiteki/model/fediverse/user.dart';

class Notification {
  final User user;
  final Post post;

  const Notification({
    this.user,
    this.post
  });

  // TODO: improve this
  String get type => null;
}
