import "package:equatable/equatable.dart";
import "package:flutter/foundation.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/model/auth/secret.dart";
import "package:kaiteki_core/social.dart" hide UserSecret, ClientSecret;
import "package:kaiteki_core/utils.dart";

@immutable
class Account extends Equatable {
  final AccountKey key;
  final AccountSecret? accountSecret;
  final ClientSecret? clientSecret;
  final BackendAdapter adapter;
  final Instance? instance;
  final User user;

  const Account({
    required this.key,
    required this.adapter,
    required this.user,
    required this.clientSecret,
    required this.accountSecret,
    this.instance,
  });

  factory Account.fromLoginResult(
    LoginSuccess result,
    BackendAdapter adapter,
    String host, {
    Instance? instance,
  }) {
    return Account(
      key: AccountKey(
        adapter.type,
        host,
        result.user.username,
      ),
      adapter: adapter,
      instance: instance,
      user: result.user,
      clientSecret: result.clientSecret.andThen(ClientSecret.fromCore),
      accountSecret: result.userSecret.andThen(AccountSecret.fromCore),
    );
  }

  @override
  List<Object?> get props => [
        key,
        accountSecret,
        clientSecret,
        adapter,
        user,
        instance,
      ];
}
