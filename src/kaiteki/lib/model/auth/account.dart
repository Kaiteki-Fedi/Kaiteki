import 'package:flutter/foundation.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/model/auth/account_key.dart';
import 'package:kaiteki/model/auth/secret.dart';

@immutable
class Account {
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
  bool operator ==(other) {
    if (other is Account) {
      return clientSecret == other.clientSecret &&
          accountSecret == other.accountSecret;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    return accountSecret.hashCode ^
        clientSecret.hashCode ^
        adapter.hashCode ^
        user.hashCode;
  }
}
