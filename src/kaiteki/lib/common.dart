// TODO(Craftplacer): export extensions, utils, etc. here

import "package:flutter/widgets.dart";

/// A record that stores an object and optionally a stack trace. Used for
/// storing errors along with their stack trace.
typedef TraceableError = (Object error, StackTrace? stackTrace);

extension AsyncSnapshotExtensions<T> on AsyncSnapshot<T> {
  TraceableError? get traceableError => hasError ? (error!, stackTrace) : null;
}
