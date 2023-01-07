import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'secret.g.dart';

@immutable
@JsonSerializable()
@HiveType(typeId: 1)
class AccountSecret extends Equatable {
  @JsonKey(name: "token")
  @HiveField(1)
  final String accessToken;

  @JsonKey(name: "refreshToken")
  @HiveField(2)
  final String? refreshToken;

  @JsonKey(name: "userId")
  @HiveField(3)
  final String? userId;

  const AccountSecret(this.accessToken, [this.refreshToken, this.userId]);

  factory AccountSecret.fromJson(Map<String, dynamic> json) =>
      _$AccountSecretFromJson(json);

  Map<String, dynamic> toJson() => _$AccountSecretToJson(this);

  @override
  List<Object?> get props => [accessToken, refreshToken, userId];
}

@JsonSerializable()
@HiveType(typeId: 2)
class ClientSecret extends Equatable {
  @JsonKey(name: "id")
  @HiveField(1)
  final String clientId;

  @JsonKey(name: "secret")
  @HiveField(2)
  final String clientSecret;

  const ClientSecret(this.clientId, this.clientSecret);

  factory ClientSecret.fromJson(Map<String, dynamic> json) =>
      _$ClientSecretFromJson(json);

  Map<String, dynamic> toJson() => _$ClientSecretToJson(this);

  @override
  List<Object?> get props => [clientId, clientSecret];
}
