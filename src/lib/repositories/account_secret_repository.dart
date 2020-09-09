import 'package:flutter/foundation.dart';
import 'package:kaiteki/model/account_secret.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSecretRepository extends ChangeNotifier {
  List<AccountSecret> _secrets;
  Iterable<AccountSecret> get secrets => List.unmodifiable(_secrets);

  SharedPreferences _preferences;
  static const String _accountListKey = "accounts";

  AccountSecretRepository(this._preferences);

  static Future<AccountSecretRepository> getInstance() async {
    var preferences = await SharedPreferences.getInstance();
    var repository = AccountSecretRepository(preferences);
    await repository._initialize();

    return repository;
  }

  Future<void> _initialize() async {
    _secrets = (await getAll()).toList();
  }

  Future<Iterable<AccountSecret>> getAll() async {
    var accounts = <String>[];
    accounts = await _getAccountList() ?? <String>[];

    var futures = accounts.map((a) async {
      var key = "a;$a";
      var value = _preferences.getString(key);

      if (value == null)
        return null;

      var keySplit = key.substring(2).split('@');

      var username = keySplit[0];
      var instance = keySplit[1];
      var accessToken = value;

      return AccountSecret(instance, username, accessToken);
    });

    var secrets = await Future.wait(futures);

    return secrets;
  }

  /// Gets a list of every account
  Future<Iterable<String>> _getAccountList() async {
    var accounts = _preferences.getStringList(_accountListKey);
    return accounts;
  }

  /// Inserts an account secret into the repository.
  Future<void> insert(AccountSecret secret) async {
    assert(
      !_secrets.contains(secret),
      "Account secret is already present in repository"
    );

    await _save(secret);

    // add reference in account list
    var key = _getKeyBySecret(secret);
    var accounts = await _getAccountList() ?? <String>[];

    assert(
      !accounts.contains(key),
      "Account secret is already present in repository's list"
    );

    var value = accounts.followedBy([key]).toList(growable: false);
    await _preferences.setStringList(_accountListKey, value);

    // add to public account list and notify listeners
    _secrets.add(secret);

    notifyListeners();
  }

  // TODO: finish remove
  Future<void> remove(AccountSecret secret) async {
    var key = _getKeyBySecret(secret);
    _preferences.remove(key);
  }

  Future<void> _save(AccountSecret secret) async {
    var key = _getKeyBySecret(secret);
    await _preferences.setString(key, secret.accessToken);
  }

  String _getKeyBySecret(AccountSecret secret) => _getKey(secret.username, secret.instance);
  String _getKey(String username, String instance) => "a;$username@$instance";
}