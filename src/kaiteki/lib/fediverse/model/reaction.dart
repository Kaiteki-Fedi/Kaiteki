import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:kaiteki/fediverse/model/emoji/emoji.dart';
import 'package:kaiteki/fediverse/model/user/user.dart';

part 'reaction.g.dart';

@CopyWith()
class Reaction {
  final List<User>? users;
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
