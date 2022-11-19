import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kaiteki/exceptions/instance_unreachable_exception.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/instances.dart';
import 'package:kaiteki/fediverse/model/instance.dart';
import 'package:kaiteki/logger.dart';
import 'package:kaiteki/model/node_info.dart';

final _logger = getLogger('InstanceProber');

Future<InstanceProbeResult> probeInstance(String host) async {
  final isInstanceAvailable = await _checkInstanceAvailability(host);
  if (!isInstanceAvailable) {
    throw InstanceUnreachableException();
  }

  InstanceProbeResult? result;

  result ??= await _probeKnownInstances(host);
  result ??= await _probeActivityPubNodeInfo(host);
  result ??= await _probeEndpoints(host);

  if (result == null) {
    _logger.d("Couldn't detect backend on on $host");
    return const InstanceProbeResult.failed();
  } else {
    final type = result.type!;

    if (result.method == null) {
      _logger.d('Detected ${type.displayName} on $host');
    } else {
      _logger.d('Detected ${type.displayName} on $host using ${result.method}');
    }

    if (result.instance == null) {
      final adapter = type.createAdapter(host);
      result = result.copyWith(instance: await adapter.getInstance());
    }

    return result;
  }
}

Future<InstanceProbeResult?> _probeKnownInstances(String host) async {
  ApiType? type;

  type = ApiType.values //
      .cast<ApiType?>()
      .firstWhere(
        (t) => (t!.hosts ?? []).contains(host),
        orElse: () => null,
      );

  if (type != null) {
    return InstanceProbeResult.successful(
      type,
      null,
      InstanceProbeMethod.knownInstances,
    );
  }

  type = (await fetchInstances())
      .cast<InstanceData?>()
      .firstWhere((i) => i!.name == host, orElse: () => null)
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

  final Map<String, dynamic> object;

  try {
    object = jsonDecode(response.body);
  } catch (e) {
    _logger.w("Failed to read nodeinfo response: $e");
    return null;
  }

  final links = (object["links"] as List<dynamic>).cast<Map<String, dynamic>>();
  final supportedLink = links.firstWhere((l) {
    final rel = (l["rel"] as String).toLowerCase();

    return rel == "http://nodeinfo.diaspora.software/ns/schema/2.1" ||
        rel == "http://nodeinfo.diaspora.software/ns/schema/2.0";
  });

  final href = supportedLink["href"] as String;
  final hrefUri = Uri.tryParse(href);

  if (hrefUri == null) {
    _logger.w("Failed to parse nodeinfo URL: $href");
    return null;
  }

  final nodeInfoResponse = await http.get(hrefUri);
  late final String nodeInfoBody;

  try {
    nodeInfoBody = nodeInfoResponse.body;
  } catch (e, s) {
    // Checking type with string because we don't depend on `http`'s dependency `string_scanner`
    final isHttpBug = e.runtimeType.toString() == "SourceSpanFormatException" &&
        (e as dynamic).message == "Invalid media type: expected no more input.";
    if (isHttpBug) {
      _logger.w(
        "Enforcing UTF-8 for nodeinfo response - "
        "see https://github.com/dart-lang/http/issues/180",
      );

      nodeInfoBody = utf8.decode(nodeInfoResponse.bodyBytes);
    } else {
      _logger.w("Failed to read body from nodeinfo response", e, s);
      return null;
    }
  }

  return NodeInfo.fromJson(jsonDecode(nodeInfoBody));
}

Future<InstanceProbeResult?> _probeActivityPubNodeInfo(String host) async {
  final nodeInfo = await fetchNodeInfo(host);
  if (nodeInfo == null) return null;

  final apiType = const {
    "mastodon": ApiType.mastodon,
    "pleroma": ApiType.pleroma,
    "misskey": ApiType.misskey,
  }[nodeInfo.software.name];

  if (apiType == null) return null;

  return InstanceProbeResult.successful(
    apiType,
    null,
    InstanceProbeMethod.nodeInfo,
  );
}

Future<InstanceProbeResult?> _probeEndpoints(String host) async {
  for (final apiType in ApiType.values) {
    try {
      final adapter = apiType.createAdapter(host);
      _logger.d('Probing for ${apiType.displayName} on $host...');

      final result = await adapter.probeInstance();

      if (result != null) {
        return InstanceProbeResult.successful(
          apiType,
          result,
          InstanceProbeMethod.endpoint,
        );
      }
    } catch (_) {
      continue;
    }
  }

  return null;
}

Future<bool> _checkInstanceAvailability(String instance) async {
  final uri = Uri.https(instance, '');

  try {
    final response = await http.get(uri);
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}

enum InstanceProbeMethod {
  knownInstances,
  nodeInfo,
  endpoint,
}

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
