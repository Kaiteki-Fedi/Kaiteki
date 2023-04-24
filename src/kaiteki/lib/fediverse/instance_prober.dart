import "dart:convert";

import "package:collection/collection.dart";
import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;
import "package:kaiteki/exceptions/instance_unreachable_exception.dart";
import "package:kaiteki/fediverse/adapter.dart";
import "package:kaiteki/fediverse/api_type.dart";
import "package:kaiteki/fediverse/instances.dart";
import "package:kaiteki/fediverse/model/instance.dart";
import "package:kaiteki/logger.dart";
import "package:kaiteki/model/node_info.dart";
import "package:kaiteki/utils/utils.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "instance_prober.g.dart";

final _logger = getLogger("InstanceProber");

@riverpod
Future<InstanceProbeResult> probeInstance(
  ProbeInstanceRef? ref,
  String host,
) async {
  if (!kIsWeb) {
    final isInstanceAvailable = await _checkInstanceAvailability(host);
    if (!isInstanceAvailable) {
      throw InstanceUnreachableException();
    }
  }

  InstanceProbeResult? result;

  try {
    result ??= await _probeKnownInstances(host);
  } catch (e, s) {
    _logger.w("Couldn't check for $host in known instances", e, s);
  }

  try {
    result ??= await _probeActivityPubNodeInfo(host);
  } catch (e, s) {
    _logger.w("Couldn't check node info for $host", e, s);
  }

  try {
    result ??= await _probeEndpoints(host);
  } catch (e, s) {
    _logger.w("Couldn't probe endpoints for $host", e, s);
  }

  if (result == null) {
    _logger.d("Couldn't detect backend on on $host");
    return const InstanceProbeResult.failed();
  }

  final type = result.type!;

  if (result.method == null) {
    _logger.d("Detected ${type.displayName} on $host");
  } else {
    _logger.d("Detected ${type.displayName} on $host using ${result.method}");
  }

  if (result.instance == null) {
    final adapter = await type.createAdapter(host);
    result = result.copyWith(instance: await adapter.getInstance());
  }

  return result;
}

Future<InstanceProbeResult?> _probeKnownInstances(String host) async {
  ApiType? type;

  type = ApiType.values //
      .cast<ApiType?>()
      .firstWhereOrNull((t) => (t!.hosts ?? []).contains(host));

  if (type != null) {
    return InstanceProbeResult.successful(
      type,
      null,
      InstanceProbeMethod.knownInstances,
    );
  }

  type = (await fetchInstances())
      .cast<InstanceData?>()
      .firstWhere((i) => i!.host == host, orElse: () => null)
      ?.type;

  if (type != null) {
    return InstanceProbeResult.successful(
      type,
      null,
      InstanceProbeMethod.knownInstances,
    );
  }

  return null;
}

Future<NodeInfo?> fetchNodeInfo(String host) async {
  final response = await http.get(Uri.https(host, "/.well-known/nodeinfo"));

  final JsonMap object;

  try {
    object = jsonDecode(response.body) as JsonMap;
  } catch (e) {
    _logger.w("Failed to read nodeinfo response: $e");
    return null;
  }

  final links = (object["links"] as List<dynamic>).cast<JsonMap>();
  final supportedLink = links.firstWhere((l) {
    final rel = (l["rel"] as String).toLowerCase();

    return RegExp(
      r"^https?:\/\/nodeinfo\.diaspora\.software\/ns\/schema\/2\.(0|1)$",
    ).hasMatch(rel);
  });

  final href = supportedLink["href"] as String;
  final hrefUri = Uri.tryParse(href);

  if (hrefUri == null) {
    _logger.w("Failed to parse nodeinfo URL: $href");
    return null;
  }

  final nodeInfoResponse = await http.get(hrefUri);
  final String nodeInfoBody;

  try {
    nodeInfoBody = utf8.decode(nodeInfoResponse.bodyBytes);
  } catch (e, s) {
    _logger.w("Failed to decode nodeinfo body", e, s);
    return null;
  }

  return NodeInfo.fromJson(jsonDecode(nodeInfoBody) as JsonMap);
}

Future<InstanceProbeResult?> _probeActivityPubNodeInfo(String host) async {
  final nodeInfo = await fetchNodeInfo(host);
  if (nodeInfo == null) return null;

  var apiType = const <String, ApiType>{
    "mastodon": ApiType.mastodon,
    "pleroma": ApiType.pleroma,
    "misskey": ApiType.misskey,
    "foundkey": ApiType.foundkey,
    "akkoma": ApiType.akkoma,
    "calckey": ApiType.calckey,
  }[nodeInfo.software.name];

  if (apiType == null) return null;
  if (apiType == ApiType.mastodon &&
      nodeInfo.software.version.contains("+glitch")) {
    apiType = ApiType.glitch;
  }

  return InstanceProbeResult.successful(
    apiType,
    null,
    InstanceProbeMethod.nodeInfo,
  );
}

Future<InstanceProbeResult?> _probeEndpoints(String host) async {
  final backends = ApiType.values
      .whereNot((e) => e.probingPriority == null)
      .sorted((a, b) => a.probingPriority!.compareTo(b.probingPriority!));

  for (final apiType in backends) {
    try {
      final adapter = await apiType.createAdapter(host);

      if (adapter is! DecentralizedBackendAdapter) continue;

      _logger.d("Probing for ${apiType.displayName} on $host...");

      final result = await adapter.probeInstance();

      if (result != null) {
        return InstanceProbeResult.successful(
          apiType,
          result,
          InstanceProbeMethod.endpoint,
        );
      }
    } catch (e, s) {
      _logger.w("Probe for ${apiType.displayName} on $host failed", e, s);
      continue;
    }
  }

  return null;
}

Future<bool> _checkInstanceAvailability(String instance) async {
  final uri = Uri.https(instance);

  try {
    final response = await http.get(uri);
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}

enum InstanceProbeMethod { knownInstances, nodeInfo, endpoint }

class InstanceProbeResult {
  final ApiType? type;
  final Instance? instance;
  final bool successful;
  final InstanceProbeMethod? method;

  const InstanceProbeResult.successful(
    this.type, [
    this.instance,
    this.method,
  ]) : successful = true;

  const InstanceProbeResult.failed()
      : successful = false,
        type = null,
        instance = null,
        method = null;

  InstanceProbeResult copyWith({ApiType? type, Instance? instance}) {
    return InstanceProbeResult.successful(
      type ?? this.type,
      instance ?? this.instance,
      method,
    );
  }
}
