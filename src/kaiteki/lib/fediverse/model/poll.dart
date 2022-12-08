class Poll<T> {
  final T? source;
  final String id;
  final bool allowMultipleChoices;
  final bool hasVoted;
  final List<PollOption> options;
  final DateTime endedAt;
  final bool hasEnded;
  final int voteCount;
  final int? voterCount;

  const Poll({
    this.source,
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
