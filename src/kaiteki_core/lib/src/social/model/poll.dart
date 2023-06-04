import 'package:kaiteki_core/src/social/model/adapted_entity.dart';

class Poll<T> extends AdaptedEntity<T> {
  final String id;
  final bool allowMultipleChoices;
  final bool hasVoted;
  final List<PollOption> options;
  final DateTime endedAt;
  final bool hasEnded;
  final int voteCount;
  final int? voterCount;

  const Poll({
    super.source,
    required this.hasEnded,
    required this.id,
    required this.allowMultipleChoices,
    this.hasVoted = false,
    this.options = const [],
    required this.endedAt,
    this.voteCount = 0,
    this.voterCount,
  });
}

class PollOption {
  final String text;
  final int? voteCount;

  const PollOption(this.text, this.voteCount);
}
