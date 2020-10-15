import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/model/auth/identity.dart';

part 'account_secret.g.dart';

@JsonSerializable()
class AccountSecret {
  final Identity identity;

  @JsonKey(name: "token")
  final String accessToken;

  const AccountSecret(this.identity, this.accessToken) :
  assert(identity != null),
  assert(accessToken != null);

  factory AccountSecret.fromJson(Map<String, dynamic> json) => _$AccountSecretFromJson(json);
  Map<String, dynamic> toJson() => _$AccountSecretToJson(this);
}