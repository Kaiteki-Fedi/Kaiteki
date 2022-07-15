import 'package:flutter/foundation.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/client_secret.dart';

@immutable
class AccountCompound {
  final AccountManager container;
  final AccountSecret accountSecret;
  final ClientSecret clientSecret;
  final FediverseAdapter adapter;
  final User account;

  ApiType? get instanceType => clientSecret.apiType;
  String get instance => clientSecret.instance;

  const AccountCompound({
    required this.container,
    required this.adapter,
    required this.account,
    required this.clientSecret,
    required this.accountSecret,
  });

  bool matchesHandle(String handle) {
    final split = handle.split('@');
    final username = split[0];
    final instance = split[1];
    return username == accountSecret.username &&
        instance == accountSecret.instance;
  }

  /// Checks whether the other [AccountCompound] has the same identifying data.
  @override
  bool operator ==(other) {
    if (other is AccountCompound) {
      return other.instance == instance && accountSecret == other.accountSecret;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    return accountSecret.hashCode ^
        clientSecret.hashCode ^
        adapter.hashCode ^
        instanceType.hashCode ^
        account.hashCode;
  }
}
