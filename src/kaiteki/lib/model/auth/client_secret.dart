import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/fediverse/api_type.dart';

part 'client_secret.g.dart';

@JsonSerializable()
class ClientSecret {
  @JsonKey(name: "id")
  final String clientId;

  @JsonKey(name: "secret")
  final String clientSecret;

  final String instance;

  @JsonKey(name: "type")
  final ApiType? apiType;

  const ClientSecret(
    this.instance,
    this.clientId,
    this.clientSecret, {
    this.apiType,
  });

  factory ClientSecret.fromJson(Map<String, dynamic> json) =>
      _$ClientSecretFromJson(json);

  Map<String, dynamic> toJson() => _$ClientSecretToJson(this);
}
