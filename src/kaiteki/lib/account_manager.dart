import "package:collection/collection.dart";
import "package:flutter/foundation.dart";
import "package:kaiteki/fediverse/model/user/user.dart";
import "package:kaiteki/logger.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/model/auth/secret.dart";
import "package:kaiteki/repositories/repository.dart";
import "package:tuple/tuple.dart";

class AccountManager extends ChangeNotifier {
  static final _logger = getLogger("AccountManager");

  Account? _currentAccount;

  Account? get current => _currentAccount ?? defaultAccount;

  set current(Account? account) {
    if (current == null) throw ArgumentError.notNull("current");
    assert(_accounts.contains(account));
    _currentAccount = account;
    notifyListeners();
  }

  Account? _defaultAccount;

  Account? get defaultAccount => _defaultAccount ?? accounts.lastOrNull;

  set defaultAccount(Account? account) {
    if (account == null) throw ArgumentError.notNull("account");
    assert(_accounts.contains(account));
    _defaultAccount = account;
    notifyListeners();
  }

  final Repository<AccountSecret, AccountKey> _accountSecrets;
  final Repository<ClientSecret, AccountKey> _clientSecrets;

  final Set<Account> _accounts = {};
  UnmodifiableListView<Account> get accounts => UnmodifiableListView(_accounts);

  AccountManager(this._accountSecrets, this._clientSecrets);

  Future<void> remove(Account account) async {
    assert(
      _accounts.contains(account),
      "The specified account doesn't exist",
    );

    await _accountSecrets.delete(account.key);

    if (account.clientSecret != null) {
      await _clientSecrets.delete(account.key);
    }

    _accounts.remove(account);
    if (_defaultAccount == account) {
      _defaultAccount = _accounts.firstOrNull;
    }

    notifyListeners();
  }

  Future<void> add(Account account) async {
    assert(
      !_accounts.contains(account),
      "An account with the same username and instance already exists",
    );

    if (account.accountSecret != null) {
      await _accountSecrets.create(account.key, account.accountSecret!);
    }
    if (account.clientSecret != null) {
      await _clientSecrets.create(account.key, account.clientSecret!);
    }

    _accounts.add(account);

    notifyListeners();
  }

  Future<void> loadAllAccounts() async {
    final accountSecrets = await _accountSecrets.read();
    final clientSecrets = await _clientSecrets.read();

    final secretPairs = accountSecrets.entries.map((kv) {
      final clientSecret = clientSecrets[kv.key];
      return Tuple3(kv.key, kv.value, clientSecret);
    });

    await Future.forEach(secretPairs, _restoreSession);

    if (_accounts.isNotEmpty) {
      // TODO(Craftplacer): Store which account the user last used
      _defaultAccount = _accounts.last;
    }
  }

  /// Retrieves the client secret for a given instance.
  Future<ClientSecret?> getClientSecret(
    String instance, [
    String? username,
  ]) async {
    final secrets = await _clientSecrets.read();
    final key = secrets.keys.firstWhereOrNull((key) {
      return key.host == instance && key.username == username;
    });
    return secrets[key];
  }

  Future<void> _restoreSession(
    Tuple3<AccountKey, AccountSecret, ClientSecret?> credentials,
  ) async {
    final key = credentials.item1;
    final accountSecret = credentials.item2;
    final clientSecret = credentials.item3;

    _logger.v("Trying to recover a ${key.type!.displayName} account");

    final adapter = key.type!.createAdapter(key.host);

    try {
      await adapter.applySecrets(clientSecret, accountSecret);
    } catch (ex, s) {
      _logger.e("Failed to apply secrets to adapter", ex, s);
      return;
    }

    User user;

    try {
      user = await adapter.getMyself();
    } catch (ex, s) {
      _logger.e("Failed to fetch user profile of authenticated user", ex, s);
      return;
    }

    final account = Account(
      key: key,
      adapter: adapter,
      user: user,
      clientSecret: clientSecret,
      accountSecret: accountSecret,
    );

    _logger.v("Signed into @${account.user.username}@${key.host}");

    await add(account);
  }
}
