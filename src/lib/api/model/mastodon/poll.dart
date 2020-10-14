import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/api/model/mastodon/emoji.dart';
part 'poll.g.dart';

@JsonSerializable()
class MastodonPoll {
  final Iterable<MastodonEmoji> emojis;

  final bool expired;

  @JsonKey(name: "expires_at")
  final DateTime expiresAt;

  final String id;

  final bool multiple;

  final Iterable<dynamic> options;

  @JsonKey(name: "own_votes")
  final Iterable<int> ownVotes;

  final bool voted;

  @JsonKey(name: "voters_count")
  final dynamic votersCount;

  @JsonKey(name: "votes_count")
  final int votesCount;

  const MastodonPoll({
    this.emojis,
    this.expired,
    this.expiresAt,
    this.id,
    this.multiple,
    this.options,
    this.ownVotes,
    this.voted,
    this.votersCount,
    this.votesCount,
  });

  factory MastodonPoll.fromJson(Map<String, dynamic> json) => _$MastodonPollFromJson(json);
}