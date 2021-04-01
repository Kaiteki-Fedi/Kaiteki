import 'package:flutter/foundation.dart';
import 'package:kaiteki/fediverse/api/adapters/fediverse_adapter.dart';
import 'package:kaiteki/fediverse/api/definitions/definitions.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/logger.dart';
import 'package:kaiteki/model/auth/account_compound.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/repositories/account_secret_repository.dart';
import 'package:kaiteki/repositories/client_secret_repository.dart';

class AccountContainer extends ChangeNotifier {
  static var _logger = getLogger("AccountContainer");

  AccountCompound? _currentAccount;
  AccountCompound get currentAccount => _currentAccount!;

  String get instance => currentAccount.clientSecret.instance;
  FediverseAdapter get adapter => currentAccount.adapter;
  bool get loggedIn => _currentAccount != null;

  final AccountSecretRepository _accountSecrets;
  final ClientSecretRepository _clientSecrets;

  List<AccountCompound> _accounts = <AccountCompound>[];
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

    var secrets = _accountSecrets.getAll();
    await Future.forEach(secrets, _restoreSession);

    if (_accounts.isNotEmpty) {
      // TODO: Store which account the user last used
      await changeAccount(_accounts.first);
    }
  }

  Future<void> _restoreSession(AccountSecret accountSecret) async {
    var instance = accountSecret.instance;
    var clientSecret = _clientSecrets.get(instance)!;

    _logger.d("Trying to recover a ${clientSecret.apiType} account");

    var adapter = ApiDefinitions.byType(clientSecret.apiType!).createAdapter();
    await adapter.client.setClientAuthentication(clientSecret);
    await adapter.client.setAccountAuthentication(accountSecret);

    // restoring user object
    User? user;
    try {
      user = await adapter.getMyself();
    } catch (ex) {
      _logger.e("Failed to verify credentials", ex);
    }

    if (user == null) {
      _logger.w("No user data was recovered, assuming user info is incorrect.");
      return;
    }

    var compound = AccountCompound(
      container: this,
      adapter: adapter,
      account: user,
      clientSecret: clientSecret,
      accountSecret: accountSecret,
    );

    _accounts.add(compound);

    _logger.d(
      "Recovered ${compound.account.displayName} @ ${compound.clientSecret.instance}",
    );
  }

  //TODO: HACK, This should not exist, please refactor.
  getClientRepo() => _clientSecrets;
}
