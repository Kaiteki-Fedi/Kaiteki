import 'package:flutter/foundation.dart' show immutable;
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/fediverse/api_type.dart';

part 'account_key.g.dart';

/// A key to be used for identifying accounts.
@immutable
@JsonSerializable()
@HiveType(typeId: 0)
class AccountKey {
  @HiveField(2)
  final String username;

  @HiveField(1)
  final String host;

  @HiveField(0)
  @JsonKey(name: "type", unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final ApiType? type;

  const AccountKey(this.type, this.host, this.username);

  factory AccountKey.fromUri(String uri) {
    final parsedUri = Uri.parse(uri);
    assert(parsedUri.userInfo.isNotEmpty);
    return AccountKey(
      ApiType.values.firstWhere(
        (t) => parsedUri.scheme == t.name,
      ),
      parsedUri.host,
      /* parsedUri.userInfo.isEmpty ? null : */ parsedUri.userInfo,
    );
  }

  Uri toUri() => Uri(scheme: type?.name, host: host, userInfo: username);

  String toHandle() => "@$username@$host";

  @override
  int get hashCode => username.hashCode ^ host.hashCode ^ type.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is AccountKey) {
      return //
          username == other.username &&
              host == other.host &&
              type == other.type;
    }

    return false;
  }

  factory AccountKey.fromJson(Map<String, dynamic> json) =>
      _$AccountKeyFromJson(json);

  Map<String, dynamic> toJson() => _$AccountKeyToJson(this);
}
