import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/src/mastodon/account.dart';
part 'emoji_reaction.g.dart';

@JsonSerializable()
class PleromaEmojiReaction {
  /// Array of accounts reacted with this emoji
  final Iterable<MastodonAccount> accounts;

  /// Count of reactions with this emoji
  final int count;

  /// Did I react with this emoji?
  final bool me;

  /// Emoji
  final String name;

  const PleromaEmojiReaction({
    required this.accounts,
    required this.count,
    required this.me,
    required this.name,
  });

  factory PleromaEmojiReaction.fromJson(Map<String, dynamic> json) =>
      _$PleromaEmojiReactionFromJson(json);

  Map<String, dynamic> toJson() => _$PleromaEmojiReactionToJson(this);
}
