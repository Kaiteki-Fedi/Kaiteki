import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:kaiteki_core/social.dart';
import 'package:kaiteki_core/utils.dart';
import 'package:logging/logging.dart';

import '../kaiteki_core_backends.dart';

final _logger = Logger('Instance Probing');

Future<InstanceProbe?> probeInstance(String host) async {
  InstanceProbe? result;

  try {
    result ??= await _checkKnownHosts(host);
  } catch (e, s) {
    _logger.warning('Failed to look for known hosts with $host', e, s);
  }

  try {
    result ??= await _probeActivityPubNodeInfo(host);
  } catch (e, s) {
    _logger.warning("Couldn't check node info for $host", e, s);
  }

  try {
    result ??= await _probeEndpoints(host);
  } catch (e, s) {
    _logger.warning("Couldn't probe endpoints for $host", e, s);
  }

  if (result == null) {
    _logger.warning("Couldn't detect backend on on $host");
    return null;
  }

  _logger.fine(
    'Detected ${result.type} on $host using ${result.method}',
  );

  return result;
}

Future<InstanceProbe?> _checkKnownHosts(String host) async {
  for (final apiType in BackendType.values) {
    final hosts = apiType.hosts;

    if (hosts == null || !hosts.contains(host)) continue;

    final BackendAdapter adapter = await apiType.createAdapter(host);

    Instance? instance;

    if (adapter is CentralizedBackendAdapter) {
      instance = adapter.instance;
    }

    return InstanceProbe(
      apiType,
      instance,
      InstanceProbeMethod.endpoint,
    );
  }
  return null;
}

Future<NodeInfo?> fetchNodeInfo(String host) async {
  final response = await http.get(Uri.https(host, '/.well-known/nodeinfo'));

  final JsonMap object;

  try {
    object = jsonDecode(response.body) as JsonMap;
  } catch (e) {
    _logger.warning('Failed to read nodeinfo response: $e');
    return null;
  }

  final links = (object['links'] as List<dynamic>).cast<JsonMap>();
  final supportedLink = links.firstWhere((l) {
    final rel = (l['rel'] as String).toLowerCase();

    return RegExp(
      r'^https?:\/\/nodeinfo\.diaspora\.software\/ns\/schema\/2\.(0|1)$',
    ).hasMatch(rel);
  });

  final href = supportedLink['href'] as String;
  final hrefUri = Uri.tryParse(href);

  if (hrefUri == null) {
    _logger.warning('Failed to parse nodeinfo URL: $href');
    return null;
  }

  final nodeInfoResponse = await http.get(hrefUri);
  final String nodeInfoBody;

  try {
    nodeInfoBody = utf8.decode(nodeInfoResponse.bodyBytes);
  } catch (e, s) {
    _logger.warning('Failed to decode nodeinfo body', e, s);
    return null;
  }

  return NodeInfo.fromJson(jsonDecode(nodeInfoBody) as JsonMap);
}

Future<InstanceProbe?> _probeActivityPubNodeInfo(String host) async {
  final nodeInfo = await fetchNodeInfo(host);
  if (nodeInfo == null) return null;

  var apiType = const <String, BackendType>{
    'mastodon': BackendType.mastodon,
    'pleroma': BackendType.pleroma,
    'misskey': BackendType.misskey,
    'foundkey': BackendType.foundkey,
    'akkoma': BackendType.akkoma,
    'calckey': BackendType.calckey,
  }[nodeInfo.software.name];

  if (apiType == null) return null;
  if (apiType == BackendType.mastodon &&
      nodeInfo.software.version.contains('+glitch')) {
    apiType = BackendType.glitch;
  }

  return InstanceProbe(
    apiType,
    null,
    InstanceProbeMethod.nodeInfo,
  );
}

Future<InstanceProbe?> _probeEndpoints(String host) async {
  final backends = BackendType.values
      .whereNot((e) => e.probingPriority == null)
      .sorted((a, b) => a.probingPriority!.compareTo(b.probingPriority!));

  for (final apiType in backends) {
    try {
      final adapter = await apiType.createAdapter(host);

      if (adapter is! DecentralizedBackendAdapter) continue;

      _logger.fine('Probing for ${apiType.name} on $host...');

      final result = await adapter.getInstance();

      return InstanceProbe(
        apiType,
        result,
        InstanceProbeMethod.endpoint,
      );
    } catch (e, s) {
      _logger.warning('Probe for ${apiType.name} on $host failed', e, s);
      continue;
    }
  }

  return null;
}

enum InstanceProbeMethod { knownInstances, nodeInfo, endpoint }

class InstanceProbe {
  final BackendType type;

  /// The instance information that was fetched while probing, if any.
  final Instance? instance;

  final InstanceProbeMethod method;

  const InstanceProbe(this.type, this.instance, this.method);
}
