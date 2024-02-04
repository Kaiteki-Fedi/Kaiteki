// TODO(Craftplacer): export extensions, utils, etc. here

import "package:flutter/widgets.dart";
import "package:kaiteki_core/utils.dart";

extension AsyncSnapshotExtensions<T> on AsyncSnapshot<T> {
  TraceableError? get traceableError => hasError ? (error!, stackTrace) : null;
}
