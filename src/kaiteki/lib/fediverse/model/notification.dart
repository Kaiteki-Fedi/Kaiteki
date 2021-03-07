import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';

class Notification {
  final User user;
  final Post post;

  const Notification({this.user, this.post});

  // TODO improve this
  String get type => null;
}
