import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'client_secret.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class ClientSecret {
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
}
