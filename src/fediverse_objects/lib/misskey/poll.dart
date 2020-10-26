import 'package:fediverse_objects/misskey/poll_choice.dart';
import 'package:json_annotation/json_annotation.dart';
part 'poll.g.dart';

@JsonSerializable()
class MisskeyPoll {
  final bool multiple;

  final DateTime expiresAt;

  final Iterable<MisskeyPollChoice> choices;

  const MisskeyPoll({
    this.multiple,
    this.expiresAt,
    this.choices,
  });

  factory MisskeyPoll.fromJson(Map<String, dynamic> json) => _$MisskeyPollFromJson(json);
}