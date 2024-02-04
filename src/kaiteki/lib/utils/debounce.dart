import "dart:async";

typedef Debounceable<S, T> = Future<S?> Function(T parameter);

/// Returns a new function that is a debounced version of the given function.
///
/// This means that the original function will be called only after no calls
/// have been made for the given Duration.
Debounceable<S, T> debounce<S, T>(
  Debounceable<S?, T> function,
  Duration duration,
) {
  DebounceTimer? debounceTimer;

  return (parameter) async {
    if (debounceTimer != null && !debounceTimer!.isCompleted) {
      debounceTimer!.cancel();
    }
    debounceTimer = DebounceTimer(duration);
    try {
      await debounceTimer!.future;
    } catch (error) {
      if (error is CancelException) {
        return null;
      }
      rethrow;
    }
    return function(parameter);
  };
}

/// A wrapper around Timer used for debouncing.
class DebounceTimer {
  DebounceTimer(Duration debounceDuration) {
    _timer = Timer(debounceDuration, _onComplete);
  }

  late final Timer _timer;
  final Completer<void> _completer = Completer<void>();

  void _onComplete() {
    _completer.complete();
  }

  Future<void> get future => _completer.future;

  bool get isCompleted => _completer.isCompleted;

  void cancel() {
    _timer.cancel();
    _completer.completeError(const CancelException());
  }
}

/// An exception indicating that the timer was canceled.
class CancelException implements Exception {
  const CancelException();
}
