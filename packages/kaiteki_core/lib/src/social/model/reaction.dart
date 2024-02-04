import 'emoji.dart';
import 'user.dart';

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

  Reaction copyWith({
    List<User>? users,
    bool? includesMe,
    Emoji? emoji,
    int? count,
  }) {
    return Reaction(
      users: users ?? this.users,
      includesMe: includesMe ?? this.includesMe,
      emoji: emoji ?? this.emoji,
      count: count ?? this.count,
    );
  }
}
