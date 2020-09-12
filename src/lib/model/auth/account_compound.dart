import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/api/api_type.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/api/clients/fediverse_client_base.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/utils/utils.dart';

class AccountCompound<A, C extends FediverseClientBase> {
  AccountContainer container;

  A account;
  C client;
  String instance;
  ClientSecret clientSecret;
  AccountSecret accountSecret;
  ApiType instanceType;

  AccountCompound(this.container, this.client, this.account, this.clientSecret, this.accountSecret) {
    assert(Utils.compareInstance(accountSecret.instance, clientSecret.instance));
    this.instance = clientSecret.instance;
  }
}