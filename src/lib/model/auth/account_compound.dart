import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/adapters/fediverse_adapter.dart';
import 'package:kaiteki/api/api_type.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/model/fediverse/user.dart';
import 'package:kaiteki/utils/utils.dart';

class AccountCompound {
  AccountContainer container;
  AccountSecret accountSecret;
  User account;

  ClientSecret clientSecret;
  FediverseAdapter adapter;

  String instance;
  ApiType instanceType;

  AccountCompound(this.container, this.adapter, this.account, this.clientSecret, this.accountSecret) {
    assert(Utils.compareInstance(accountSecret.instance, clientSecret.instance));
    this.instance = clientSecret.instance;
  }
}