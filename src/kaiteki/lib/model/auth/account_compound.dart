import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/fediverse/api/adapters/fediverse_adapter.dart';
import 'package:kaiteki/fediverse/api/api_type.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/client_secret.dart';

class AccountCompound {
  final AccountContainer container;
  final AccountSecret accountSecret;
  final ClientSecret clientSecret;
  final FediverseAdapter adapter;
  ApiType? get instanceType => clientSecret.apiType;

  User account;
  String get instance => clientSecret.instance;

  AccountCompound({
    required this.container,
    required this.adapter,
    required this.account,
    required this.clientSecret,
    required this.accountSecret,
  });
  // TODO assert check has been removed, due to compiler errors
  //: assert(accountSecret.identity.instance.equalsIgnoreCase(clientSecret.instance));
}
