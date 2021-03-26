import 'package:json_annotation/json_annotation.dart';
part 'mention.g.dart';

/// Represents a mention of a user within the content of a status.
@JsonSerializable()
class MastodonMention {
  /// The webfinger acct: URI of the mentioned user.
  ///
  /// Equivalent to `username` for local users, or `username@domain` for remote users.
  @JsonKey(name: 'acct')
  final String account;

  /// The account id of the mentioned user.
  final String id;

  /// The location of the mentioned user's profile.
  final String url;

  /// The username of the mentioned user.
  final String username;

  const MastodonMention({
    required this.account,
    required this.id,
    required this.url,
    required this.username,
  });

  factory MastodonMention.fromJson(Map<String, dynamic> json) =>
      _$MastodonMentionFromJson(json);

  Map<String, dynamic> toJson() => _$MastodonMentionToJson(this);
}
