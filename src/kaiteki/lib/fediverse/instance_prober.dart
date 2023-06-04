import "package:flutter/foundation.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:kaiteki_core/kaiteki_core.dart" as core;
import "package:riverpod_annotation/riverpod_annotation.dart";

part "instance_prober.g.dart";

@riverpod
Future<core.InstanceProbeResult> probeInstance(
  ProbeInstanceRef? ref,
  String host,
) async {
  return core.probeInstance(host, checkAvailability: !kIsWeb);
}
