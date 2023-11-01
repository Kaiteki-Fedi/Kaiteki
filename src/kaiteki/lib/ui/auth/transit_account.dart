import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki_core/social.dart";

part "transit_account.g.dart";

/// A data class intended to carry the core information of an account for
/// transit between devices.
@JsonSerializable(includeIfNull: false)
class TransitAccount {
  final String username;
  final String instance;
  final ApiType apiType;
  final String accessToken;
  final String? refreshToken;
  final String? userId;
  final String? clientId;
  final String? clientSecret;

  const TransitAccount({
    required this.username,
    required this.instance,
    required this.apiType,
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.clientId,
    required this.clientSecret,
  });

  factory TransitAccount.fromAccount(Account account) {
    return TransitAccount(
      username: account.key.username,
      instance: account.key.host,
      apiType: account.key.type!,
      accessToken: account.accountSecret!.accessToken,
      refreshToken: account.accountSecret?.refreshToken,
      userId: account.accountSecret?.userId,
      clientId: account.clientSecret?.clientId,
      clientSecret: account.clientSecret?.clientSecret,
    );
  }

  factory TransitAccount.fromJson(Map<String, dynamic> json) =>
      _$TransitAccountFromJson(json);

  Map<String, dynamic> toJson() => _$TransitAccountToJson(this);
}
