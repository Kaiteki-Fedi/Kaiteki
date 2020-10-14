import 'package:json_annotation/json_annotation.dart';
part 'mention.g.dart';

@JsonSerializable()
class MastodonMention {
  @JsonKey(name: "acct")
  final String account;

  final String id;

  final String url;

  final String username;

  const MastodonMention({
    this.account,
    this.id,
    this.url,
    this.username,
  });

  factory MastodonMention.fromJson(Map<String, dynamic> json) => _$MastodonMentionFromJson(json);
}