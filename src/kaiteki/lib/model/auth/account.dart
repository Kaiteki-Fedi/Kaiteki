import "package:equatable/equatable.dart";
import "package:flutter/foundation.dart";
import "package:kaiteki/fediverse/adapter.dart";
import "package:kaiteki/fediverse/model/user/user.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/model/auth/secret.dart";

@immutable
class Account extends Equatable {
  final AccountKey key;
  final AccountSecret? accountSecret;
  final ClientSecret? clientSecret;
  final BackendAdapter adapter;
  final User user;

  const Account({
    required this.key,
    required this.adapter,
    required this.user,
    required this.clientSecret,
    required this.accountSecret,
  });

  @override
  List<Object?> get props => [key, accountSecret, clientSecret, adapter, user];
}
