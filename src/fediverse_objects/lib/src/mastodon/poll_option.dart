import 'package:json_annotation/json_annotation.dart';
part 'poll_option.g.dart';

@JsonSerializable()
class MastodonPollOption {
  final String title;

  @JsonKey(name: 'votes_count')
  final int? votesCount;

  MastodonPollOption({
    required this.title,
    this.votesCount,
  });

  factory MastodonPollOption.fromJson(Map<String, dynamic> json) =>
      _$MastodonPollOptionFromJson(json);

  Map<String, dynamic> toJson() => _$MastodonPollOptionToJson(this);
}
