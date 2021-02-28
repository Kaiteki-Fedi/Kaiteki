import 'package:flutter/foundation.dart';
import 'package:kaiteki/api/adapters/fediverse_adapter.dart';
import 'package:kaiteki/api/clients/mastodon_client.dart';
import 'package:kaiteki/api/definitions/definitions.dart';
import 'package:kaiteki/logger.dart';
import 'package:kaiteki/model/auth/account_compound.dart';
import 'package:kaiteki/model/fediverse/user.dart';
import 'package:kaiteki/repositories/account_secret_repository.dart';
import 'package:kaiteki/repositories/client_secret_repository.dart';

class AccountContainer extends ChangeNotifier {
  static var _logger = getLogger("AccountContainer");

  AccountCompound _currentAccount;
  AccountCompound get currentAccount => _currentAccount;

  String get instance => currentAccount.clientSecret.instance;
  FediverseAdapter get adapter => currentAccount.adapter;
  bool get loggedIn => currentAccount != null;

  final AccountSecretRepository _accountSecrets;
  final ClientSecretRepository _clientSecrets;

  List<AccountCompound> _accounts = List<AccountCompound>();
  Iterable<AccountCompound> get accounts => List.unmodifiable(_accounts);

  AccountContainer(this._accountSecrets, this._clientSecrets);

  Future<void> remove(AccountCompound compound) async {
    _accounts.remove(compound);
    await _accountSecrets.remove(compound.accountSecret);
    await _clientSecrets.remove(compound.clientSecret);

    notifyListeners();

    _logger.d("removed account ${compound.instance}");
  }

  Future<void> addCurrentAccount(AccountCompound compound) async {
    // TODO add duplicate check
    _accounts.add(compound);
    _accountSecrets.insert(compound.accountSecret);
    _clientSecrets.insert(compound.clientSecret);

    await changeAccount(compound);
  }

  Future<void> changeAccount(AccountCompound account) async {
    assert(_accounts.contains(account));

    _currentAccount = account;

    notifyListeners();
  }

  Future<void> loadAllAccounts() async {
    _accounts.clear();
    _accountSecrets.getAll().forEach((accountSecret) async {
      if (accountSecret == null) {
        _logger.w("A saved account secret was null");
        return;
      }

      var instance = accountSecret.instance;
      var clientSecret = _clientSecrets.get(instance);

      _logger.d(clientSecret.apiType.toString());

      if (clientSecret == null || clientSecret.apiType == null) {
        _logger.w("Skipped loading account secret due to invalid client secret.");
        return;
      }

      var adapter = ApiDefinitions.byType(clientSecret.apiType).createAdapter();

      User user;

      // TODO Redesign class structure to make this not Mastodon-specific.
      if (adapter.client is MastodonClient) {
        var mastodonClient = adapter.client as MastodonClient;

        mastodonClient.instance = clientSecret.instance;

        mastodonClient.authenticationData.clientSecret =
            clientSecret.clientSecret;

        mastodonClient.authenticationData.clientId = clientSecret.clientId;

        mastodonClient.authenticationData.accessToken =
            accountSecret.accessToken;
      }

      // restoring user object
      try {
        user = await adapter.getMyself();
      } catch (ex) {
        _logger.e("Failed to verify credentials", ex);
      }

      if (user == null) {
        _logger.w("No user data was recovered, assuming user info is incorrect.");
        return;
      }

      var accountCompound = AccountCompound(
        container: this,
        adapter: adapter,
        account: user,
        clientSecret: clientSecret,
        accountSecret: accountSecret,
        instanceType: clientSecret.apiType,
      );
      _accounts.add(accountCompound);
    });
  }

  //TODO: HACK, This should not exist, please refactor.
  getClientRepo() => _clientSecrets;

  /// Restores the account objects on each compound.
  ///
  /// In the case if the server refuses to return something, the compound will
  /// be removed from the account list.
  Future<void> checkAccounts() async {
    for (var compound in _accounts) {
      try {
        var account = await compound.adapter.getMyself();

        if (account == null) throw "Account was null";

        compound.account = account;
      } catch (e) {
        _logger.e("Account retrieval failed, removing account...", e);
        remove(compound);
      }
    }
  }
}
