import 'package:json_annotation/json_annotation.dart';

part 'poll_choice.g.dart';

// https://github.com/misskey-dev/misskey/blob/develop/packages/backend/src/core/entities/NoteEntityService.ts#L133
@JsonSerializable()
class PollChoice {
  final String text;
  final int votes;

  // Misskey source code has this set to false by default.
  final bool isVoted;

  const PollChoice({
    required this.text,
    required this.votes,
    required this.isVoted,
  });

  factory PollChoice.fromJson(Map<String, dynamic> json) =>
      _$PollChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$PollChoiceToJson(this);
}
