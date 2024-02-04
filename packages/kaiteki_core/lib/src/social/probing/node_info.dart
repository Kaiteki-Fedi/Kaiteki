import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';
part 'node_info.g.dart';

@JsonSerializable()
class NodeInfo {
  final String version;

  /// Metadata about server software in use.
  final Software software;

  /// The protocols supported on this server.
  final List<Protocol> protocols;

  /// Free form key value pairs for software specific values. Clients should not rely on any specific key present.
  final JsonMap metadata;

  const NodeInfo({
    required this.version,
    required this.software,
    required this.protocols,
    this.metadata = const {},
  });

  factory NodeInfo.fromJson(JsonMap json) => _$NodeInfoFromJson(json);

  JsonMap toJson() => _$NodeInfoToJson(this);
}

@JsonSerializable()
class Software {
  final String name;
  final String version;
  final String? repository;
  final String? homepage;

  const Software({
    required this.name,
    required this.version,
    this.repository,
    this.homepage,
  });

  factory Software.fromJson(JsonMap json) => _$SoftwareFromJson(json);

  JsonMap toJson() => _$SoftwareToJson(this);
}

enum Protocol {
  activitypub,
  buddycloud,
  dfrn,
  diaspora,
  libertree,
  ostatus,
  pumpio,
  tent,
  xmpp,
  zot
}
