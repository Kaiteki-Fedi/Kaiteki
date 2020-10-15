import 'package:flutter/foundation.dart';
import 'package:kaiteki/api/adapters/fediverse_adapter.dart';
import 'package:kaiteki/api/adapters/mastodon_adapter.dart';
import 'package:kaiteki/api/adapters/misskey_adapter.dart';
import 'package:kaiteki/api/adapters/pleroma_adapter.dart';
import 'package:kaiteki/api/api_type.dart';
import 'package:kaiteki/api/clients/mastodon_client.dart';
import 'package:kaiteki/model/auth/account_compound.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/model/fediverse/user.dart';
import 'package:kaiteki/repositories/account_secret_repository.dart';
import 'package:kaiteki/repositories/client_secret_repository.dart';
import 'package:kaiteki/utils/logger.dart';

class AccountContainer extends ChangeNotifier {
  AccountCompound _currentAccount;
  AccountCompound get currentAccount => _currentAccount;

  String get instance => currentAccount.clientSecret.instance;
  FediverseAdapter get adapter => currentAccount.adapter;
  bool get loggedIn => currentAccount != null;

  final AccountSecretRepository _accountSecrets;
  final ClientSecretRepository _clientSecrets;
  List<AccountCompound> _accounts = List<AccountCompound>();

  AccountContainer(this._accountSecrets, this._clientSecrets);

  Future<List<AccountCompound>> getAvailableAccounts() async {
    return _accounts;
  }

  Future<void> clear() async {
    remove(currentAccount);
    _accounts.clear();

    notifyListeners();

    Logger.debug("cleared accounts");
  }

  void remove(AccountCompound compound) {
    _accounts.remove(compound);
    _accountSecrets.remove(compound.accountSecret);
    // _clientSecrets.remove(compound.accountSecret);

    notifyListeners();

    Logger.debug("removed account ${compound.instance}");
  }

  Future<void> addCurrentAccount(AccountCompound compound) async {
    // TODO: add duplicate check
    _accounts.add(compound);
    _accountSecrets.insert(compound.accountSecret);

    await changeAccount(compound);
  }

  Future<void> changeAccount(AccountCompound account) async {
    assert(_accounts.contains(account));

    _currentAccount = account;

    notifyListeners();
  }

  Future<void> loadAllAccounts() async {
    _accounts.clear();
    _accountSecrets.secrets.forEach((accountSecret) async {
      if (accountSecret == null)
        return;

      var instance = accountSecret.instance;
      var clientSecret = await ClientSecret.getSecret(instance);

      assert(clientSecret != null);

      // TODO: Add support for other client types
      // var type = ApiType.Pleroma;
      var adapter = createAdapter(clientSecret.apiType);

      User user;

      if (adapter.client is MastodonClient) {
        var mastodonClient = adapter.client as MastodonClient;

        mastodonClient.instance = clientSecret.instance;

        mastodonClient.authenticationData.clientSecret =
            clientSecret.clientSecret;

        mastodonClient.authenticationData.clientId = clientSecret.clientId;

        mastodonClient.authenticationData.accessToken =
            accountSecret.accessToken;
      }

      try {
        user = await adapter.getMyself();
      } catch (ex) {
        print("Failed to verify credentials: $ex");
      }

      if (user == null) {
        print("No user data was recovered, assuming user info is incorrect.");
        return;
      }

      var accountCompound = AccountCompound(this, adapter, user, clientSecret, accountSecret);
      _accounts.add(accountCompound);
    });
  }

  FediverseAdapter createAdapter(ApiType type){
    switch (type) {
      case ApiType.Mastodon: return MastodonAdapter();
      case ApiType.Pleroma: return PleromaAdapter();
      case ApiType.Misskey: return MisskeyAdapter();
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
        var account = await compound.adapter.getMyself();

        if (account == null) {
          throw "Account was null";
        }

        compound.account = account;
      } catch (e) {
        remove(compound);
        Logger.error("Account retrieval failed, removing account... $e");
      }
    }
  }
}