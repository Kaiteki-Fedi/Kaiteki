import 'package:kaiteki/model/fediverse/emoji.dart';
import 'package:kaiteki/model/fediverse/user.dart';

class Reaction {
  final Iterable<User> users;
  final bool includesMe;
  final Emoji emoji;
  final int count;

  const Reaction({this.emoji, this.users, this.includesMe, this.count});
}