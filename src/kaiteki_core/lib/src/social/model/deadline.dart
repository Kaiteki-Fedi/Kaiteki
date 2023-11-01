/// A class that represents a deadline.
///
/// A deadline can be either relative to the current time or absolute.
sealed class Deadline {
  DateTime get endsAt;

  const Deadline();

  RelativeDeadline ensureRelative([DateTime? currentTime]) {
    final deadline = this;
    return switch (deadline) {
      RelativeDeadline() => deadline,
      AbsoluteDeadline() => RelativeDeadline(
          deadline.endsAt.difference(currentTime ?? DateTime.now()),
        ),
    };
  }

  AbsoluteDeadline ensureAbsolute([DateTime? currentTime]) {
    final deadline = this;
    return switch (deadline) {
      AbsoluteDeadline() => deadline,
      RelativeDeadline() => AbsoluteDeadline(
          (currentTime ?? DateTime.now()).add(deadline.duration),
        ),
    };
  }
}

/// A deadline that is relative to the current time.
class RelativeDeadline extends Deadline {
  final Duration duration;

  const RelativeDeadline(this.duration);

  @override
  DateTime get endsAt => DateTime.now().add(duration);
}

/// A deadline that is absolute.
class AbsoluteDeadline extends Deadline {
  @override
  final DateTime endsAt;

  const AbsoluteDeadline(this.endsAt);
}
