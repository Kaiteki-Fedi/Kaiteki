import 'package:fediverse_objects/src/mastodon/account.dart';
import 'package:json_annotation/json_annotation.dart';

part 'emoji_reaction.g.dart';

@JsonSerializable()
class EmojiReaction {
  /// Array of accounts reacted with this emoji
  final Iterable<Account> accounts;

  /// Count of reactions with this emoji
  final int count;

  /// Did I react with this emoji?
  final bool me;

  /// Emoji
  final String name;

  const EmojiReaction({
    required this.accounts,
    required this.count,
    required this.me,
    required this.name,
  });

  factory EmojiReaction.fromJson(Map<String, dynamic> json) =>
      _$EmojiReactionFromJson(json);

  Map<String, dynamic> toJson() => _$EmojiReactionToJson(this);
}
