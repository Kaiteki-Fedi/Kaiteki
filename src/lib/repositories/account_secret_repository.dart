import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSecretRepository extends ChangeNotifier {
  List<AccountSecret> _secrets;
  Iterable<AccountSecret> get secrets => List.unmodifiable(_secrets);

  final SharedPreferences _preferences;

  AccountSecretRepository(this._preferences);

  static Future<AccountSecretRepository> getInstance([SharedPreferences preferences]) async {
    if (preferences == null)
      preferences = await SharedPreferences.getInstance();

    var repository = AccountSecretRepository(preferences);
    return await repository._initialize();
  }

  Future<void> _initialize() async {
    var json = _preferences.getString("accounts");

    if (json == null) {
      _secrets = <AccountSecret>[];
      return;
    }

    var accountsJson = jsonDecode(json);
    var accounts = accountsJson.map<AccountSecret>((json) => AccountSecret.fromJson(json));
    _secrets = accounts.toList();
  }

  /// Inserts an account secret into the repository.
  Future<void> insert(AccountSecret secret) async {
    assert(
      !_secrets.contains(secret),
      "Account secret is already present in repository",
    );

    // add to public account list
    _secrets.add(secret);

    await _save();

    notifyListeners();
  }

  Future<void> remove(AccountSecret secret) async {
    _secrets.remove(secret);
    await _save();

    notifyListeners();
  }

  Future<void> _save() async {
    var jsonList = _secrets.map((s) => s.toJson()).toList();
    var json = jsonEncode(jsonList);
    await _preferences.setString("accounts", json);
  }
}