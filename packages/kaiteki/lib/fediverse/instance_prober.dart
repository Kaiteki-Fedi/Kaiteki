import "package:flutter/foundation.dart";
import "package:kaiteki_core_backends/kaiteki_core_backends.dart" as probing;
import "package:riverpod_annotation/riverpod_annotation.dart";

part "instance_prober.g.dart";

@riverpod
Future<probing.InstanceProbe?> probeInstance(
  ProbeInstanceRef? ref,
  String host,
) async => probing.probeInstance(host);
