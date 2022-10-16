import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_secret.g.dart';

@immutable
@JsonSerializable()
@HiveType(typeId: 1)
class AccountSecret {
  @JsonKey(name: "token")
  @HiveField(1)
  final String accessToken;

  const AccountSecret(this.accessToken);

  factory AccountSecret.fromJson(Map<String, dynamic> json) =>
      _$AccountSecretFromJson(json);

  Map<String, dynamic> toJson() => _$AccountSecretToJson(this);

  @override
  bool operator ==(Object other) {
    return other is AccountSecret && accessToken == other.accessToken;
  }

  @override
  int get hashCode => accessToken.hashCode;
}
