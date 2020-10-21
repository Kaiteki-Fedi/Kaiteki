import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/mastodon/account.dart';
part 'emoji_reaction.g.dart';

@JsonSerializable(createToJson: false)
class PleromaEmojiReaction {
  final Iterable<MastodonAccount> accounts;

  final int count;

  final bool me;

  final String name;

  const PleromaEmojiReaction({
    this.accounts,
    this.count,
    this.me,
    this.name,
  });

  factory PleromaEmojiReaction.fromJson(Map<String, dynamic> json) =>
      _$PleromaEmojiReactionFromJson(json);
}
