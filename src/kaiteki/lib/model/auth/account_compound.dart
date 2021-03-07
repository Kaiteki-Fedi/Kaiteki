import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/fediverse/api/adapters/fediverse_adapter.dart';
import 'package:kaiteki/fediverse/api/api_type.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/fediverse/model/user.dart';

class AccountCompound {
  final AccountContainer container;
  final AccountSecret accountSecret;
  final ClientSecret clientSecret;
  final FediverseAdapter adapter;
  final ApiType instanceType;

  User account;
  String get instance => clientSecret.instance;

  AccountCompound({
    this.container,
    this.instanceType,
    this.adapter,
    this.account,
    this.clientSecret,
    this.accountSecret,
  });
  // TODO assert check has been removed, due to compiler errors
  //: assert(accountSecret.identity.instance.equalsIgnoreCase(clientSecret.instance));
}
