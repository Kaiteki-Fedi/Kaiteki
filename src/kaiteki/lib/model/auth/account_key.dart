import "package:equatable/equatable.dart";
import "package:flutter/foundation.dart" show immutable;
import "package:hive/hive.dart";
import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/fediverse/api_type.dart";
import "package:kaiteki/fediverse/model/user/handle.dart";
import "package:kaiteki/utils/utils.dart";

part "account_key.g.dart";

/// A key to be used for identifying accounts.
@immutable
@JsonSerializable()
@HiveType(typeId: 0)
class AccountKey extends Equatable {
  @HiveField(2)
  final String username;

  @HiveField(1)
  final String host;

  @HiveField(0)
  @JsonKey(name: "type", unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final ApiType? type;

  UserHandle get handle => UserHandle(username, host);

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

  factory AccountKey.fromJson(JsonMap json) => _$AccountKeyFromJson(json);

  JsonMap toJson() => _$AccountKeyToJson(this);

  @override
  List<Object?> get props => [username, host, type];
}
