import 'package:kaiteki/fediverse/model/emoji.dart';
import 'package:kaiteki/fediverse/model/user.dart';

class Reaction {
  final Iterable<User>? users;
  final bool includesMe;
  final Emoji emoji;
  final int count;

  const Reaction({
    required this.emoji,
    required this.includesMe,
    required this.count,
    this.users,
  });
}
