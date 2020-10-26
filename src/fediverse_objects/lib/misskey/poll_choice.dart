import 'package:json_annotation/json_annotation.dart';
part 'poll_choice.g.dart';

@JsonSerializable()
class MisskeyPollChoice {
  final String text;

  final int votes;

  final bool isVoted;

  const MisskeyPollChoice({
    this.text,
    this.votes,
    this.isVoted,
  });

  factory MisskeyPollChoice.fromJson(Map<String, dynamic> json) => _$MisskeyPollChoiceFromJson(json);
}