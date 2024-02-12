import 'package:json_annotation/json_annotation.dart';

import 'poll_choice.dart';

part 'poll.g.dart';

// https://github.com/misskey-dev/misskey/blob/develop/packages/backend/src/core/entities/NoteEntityService.ts#L164-L168
@JsonSerializable()
class Poll {
  final bool multiple;
  final DateTime? expiresAt;
  final List<PollChoice> choices;

  const Poll({
    required this.multiple,
    required this.expiresAt,
    required this.choices,
  });

  factory Poll.fromJson(Map<String, dynamic> json) => _$PollFromJson(json);

  Map<String, dynamic> toJson() => _$PollToJson(this);
}
