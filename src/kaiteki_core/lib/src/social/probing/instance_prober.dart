import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:kaiteki_core/utils.dart';
import 'package:logging/logging.dart';

import '../adapter.dart';
import '../api_type.dart';
import '../model/instance.dart';
import 'instance_unreachable_exception.dart';
import 'node_info.dart';

final _logger = Logger('Instance Probing');

Future<InstanceProbeResult> probeInstance(
  String host, {
  bool checkAvailability = true,
}) async {
  if (checkAvailability) {
    final isInstanceAvailable = await _checkInstanceAvailability(host);
    if (!isInstanceAvailable) throw InstanceUnreachableException();
  }

  InstanceProbeResult? result;

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
    return const InstanceProbeResult.failed();
  }

  final type = result.type!;

  if (result.method == null) {
    _logger.fine('Detected ${type.displayName} on $host');
  } else {
    _logger
        .fine('Detected ${type.displayName} on $host using ${result.method}');
  }

  if (result.instance == null) {
    final adapter = await type.createAdapter(host);
    result = result.copyWith(instance: await adapter.getInstance());
  }

  return result;
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

Future<InstanceProbeResult?> _probeActivityPubNodeInfo(String host) async {
  final nodeInfo = await fetchNodeInfo(host);
  if (nodeInfo == null) return null;

  var apiType = const <String, ApiType>{
    'mastodon': ApiType.mastodon,
    'pleroma': ApiType.pleroma,
    'misskey': ApiType.misskey,
    'foundkey': ApiType.foundkey,
    'akkoma': ApiType.akkoma,
    'calckey': ApiType.calckey,
  }[nodeInfo.software.name];

  if (apiType == null) return null;
  if (apiType == ApiType.mastodon &&
      nodeInfo.software.version.contains('+glitch')) {
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

      _logger.fine('Probing for ${apiType.displayName} on $host...');

      final result = await adapter.probeInstance();

      if (result != null) {
        return InstanceProbeResult.successful(
          apiType,
          result,
          InstanceProbeMethod.endpoint,
        );
      }
    } catch (e, s) {
      _logger.warning('Probe for ${apiType.displayName} on $host failed', e, s);
      continue;
    }
  }

  return null;
}

Future<bool> _checkInstanceAvailability(String instance) async {
  final uri = Uri.https(instance);

  try {
    final request = Request('GET', uri)..followRedirects = false;
    final response = await request.send();
    return HttpStatus.ok <= response.statusCode &&
        response.statusCode < HttpStatus.badRequest;
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
