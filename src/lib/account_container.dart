import 'package:flutter/foundation.dart';
import 'package:kaiteki/model/account_compound.dart';
import 'package:kaiteki/model/account_secret.dart';
import 'package:kaiteki/api/api_type.dart';
import 'package:kaiteki/api/clients/fediverse_client_base.dart';
import 'package:kaiteki/api/clients/mastodon_client.dart';
import 'package:kaiteki/api/clients/pleroma_client.dart';
import 'package:kaiteki/model/client_secret.dart';
import 'package:kaiteki/api/model/mastodon/account.dart';
import 'package:kaiteki/utils/logger.dart';
import 'package:kaiteki/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountContainer extends ChangeNotifier {
  AccountCompound _currentAccount;

  AccountCompound get currentAccount => _currentAccount;
  ClientSecret get clientSecret => currentAccount.clientSecret;
  AccountSecret get accountSecret => currentAccount.accountSecret;
  FediverseClientBase get client => currentAccount.client;

  String get instance => clientSecret.instance;
  bool get loggedIn => currentAccount != null;

  List<AccountCompound> _accounts = List<AccountCompound>();

  Future<List<AccountCompound>> getAvailableAccounts() async {
    return _accounts;
  }

  Future<void> reset() async {
    throw "check";

    notifyListeners();

    Logger.debug("reset account container");
  }

  Future<void> clear() async {
    remove(currentAccount);
    _accounts.clear();

    notifyListeners();

    Logger.debug("cleared accounts");
  }

  void remove(AccountCompound compound) {
    _accounts.remove(compound);

    notifyListeners();

    Logger.debug("removed account ${compound.instance}");
  }

  Future<void> addCurrentAccount(AccountCompound compound) async {
    // TODO: add duplicate check
    _accounts.add(compound);

    await changeAccount(compound);
  }

  Future<void> _saveAccountList() async {
    var preferences = await SharedPreferences.getInstance();
    var ids = _accounts.map((a) => "${a.accountSecret.username}@${a.accountSecret.instance}");
    await preferences.setStringList("accounts", ids);
  }

  Future<void> changeAccount(AccountCompound account) async {
    assert(_accounts.contains(account));

    _currentAccount = account;

    notifyListeners();
  }

  Future<void> loadAllAccounts() async {
    var secrets = await AccountSecret.getSecrets();

    _accounts.clear();
    secrets.forEach((accountSecret) async {
      if (accountSecret == null)
        return;

      var instance = accountSecret.instance;
      var clientSecret = await ClientSecret.getSecret(instance);

      assert(clientSecret != null);

      // TODO: Add support for other client types
      var type = ApiType.Pleroma;
      var client = createClient(type);

      dynamic account;

      if (client is PleromaClient) {
        client.instance = clientSecret.instance;
        client.clientSecret = clientSecret.clientSecret;
        client.clientId = clientSecret.clientId;
        client.accessToken = accountSecret.accessToken;

        try {
          account = await client.verifyCredentials();
        } catch (ex) {
          print("Failed to verify credentials: $ex");
        }
      }

      if (account == null) {
        print("No account data was recovered, assuming account info is incorrect.");
      }

      var accountCompound = AccountCompound(this, client, account, clientSecret, accountSecret);
      _accounts.add(accountCompound);
    });
  }

  FediverseClientBase createClient(ApiType type){
    switch (type) {
      case ApiType.Mastodon: return MastodonClient();
      case ApiType.Pleroma: return PleromaClient();
      default: throw "out of range";
    }
  }

  /// Restores the account objects on each compound.
  ///
  /// In the case if the server refuses to return something, the compound will
  /// be removed from the account list.
  Future<void> checkAccounts() async {
    for (var compound in _accounts) {
      try {
        if (compound.client is MastodonClient) {
          var mastodonClient = compound.client as MastodonClient;
          var account = mastodonClient.verifyCredentials();

          if (account == null) throw "Account was null";

          compound.account = account;
        } else {
          throw "Unsupported client";
        }
      } catch (e) {
        remove(compound);
        Logger.error("Account retrieval failed, removing account... $e");
      }
    }
  }
}