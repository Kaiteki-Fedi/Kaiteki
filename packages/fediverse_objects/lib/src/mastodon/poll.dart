import 'package:json_annotation/json_annotation.dart';

import 'custom_emoji.dart';
import 'poll_option.dart';

part 'poll.g.dart';

@JsonSerializable()
class Poll {
  /// Custom emoji to be used for rendering poll options.
  final List<CustomEmoji> emojis;

  /// Is the poll currently expired?
  final bool expired;

  /// When the poll ends.
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;

  /// The ID of the poll in the database.
  final String id;

  /// Does the poll allow multiple-choice answers?
  final bool multiple;

  /// Possible answers for the poll.
  final List<PollOption> options;

  /// When called with a user token, which options has the authorized user chosen?
  ///
  /// Contains an array of index values for `options`.
  @JsonKey(name: 'own_votes')
  final List<int>? ownVotes;

  /// When called with a user token, has the authorized user voted?
  final bool? voted;

  /// How many unique accounts have voted on a multiple-choice poll.
  @JsonKey(name: 'voters_count')
  final int? votersCount;

  /// How many votes have been received.
  @JsonKey(name: 'votes_count')
  final int votesCount;

  const Poll({
    required this.id,
    required this.expiresAt,
    required this.expired,
    required this.multiple,
    required this.emojis,
    required this.options,
    required this.ownVotes,
    required this.voted,
    required this.votersCount,
    required this.votesCount,
  });

  factory Poll.fromJson(Map<String, dynamic> json) => _$PollFromJson(json);

  Map<String, dynamic> toJson() => _$PollToJson(this);
}
