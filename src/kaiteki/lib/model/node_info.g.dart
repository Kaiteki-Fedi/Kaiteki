// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NodeInfo _$NodeInfoFromJson(Map<String, dynamic> json) => NodeInfo(
      version: json['version'] as String,
      software: Software.fromJson(json['software'] as Map<String, dynamic>),
      protocols: (json['protocols'] as List<dynamic>)
          .map((e) => $enumDecode(_$ProtocolEnumMap, e))
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$NodeInfoToJson(NodeInfo instance) => <String, dynamic>{
      'version': instance.version,
      'software': instance.software,
      'protocols': instance.protocols.map((e) => _$ProtocolEnumMap[e]).toList(),
      'metadata': instance.metadata,
    };

const _$ProtocolEnumMap = {
  Protocol.activitypub: 'activitypub',
  Protocol.buddycloud: 'buddycloud',
  Protocol.dfrn: 'dfrn',
  Protocol.diaspora: 'diaspora',
  Protocol.libertree: 'libertree',
  Protocol.ostatus: 'ostatus',
  Protocol.pumpio: 'pumpio',
  Protocol.tent: 'tent',
  Protocol.xmpp: 'xmpp',
  Protocol.zot: 'zot',
};

Software _$SoftwareFromJson(Map<String, dynamic> json) => Software(
      name: json['name'] as String,
      version: json['version'] as String,
      repository: json['repository'] as String?,
      homepage: json['homepage'] as String?,
    );

Map<String, dynamic> _$SoftwareToJson(Software instance) => <String, dynamic>{
      'name': instance.name,
      'version': instance.version,
      'repository': instance.repository,
      'homepage': instance.homepage,
    };
