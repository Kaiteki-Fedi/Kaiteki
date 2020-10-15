import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kaiteki/utils/string_extensions.dart';

class ClientSecretRepository extends ChangeNotifier {
  List<ClientSecret> _secrets;
  Iterable<ClientSecret> get secrets => List.unmodifiable(_secrets);

  final SharedPreferences _preferences;

  ClientSecretRepository(this._preferences);

  static Future<ClientSecretRepository> getInstance() async {
    var preferences = await SharedPreferences.getInstance();
    var repository = ClientSecretRepository(preferences);
    await repository._initialize();

    return repository;
  }

  Future<void> _initialize() async {
    var json = _preferences.getString("clientSecrets");

    if (json == null) {
      _secrets = <ClientSecret>[];
      return;
    }

    var accountsJson = jsonDecode(json);
    var accounts = accountsJson.map<ClientSecret>((json) => ClientSecret.fromJson(json));
    _secrets = accounts.toList();
  }

  Future<void> insert(ClientSecret secret) async {
    assert(
      !_secrets.contains(secret),
      "Client secret is already present in repository",
    );

    // add to public account list
    _secrets.add(secret);

    await _save();

    notifyListeners();
  }

  Future<void> remove(ClientSecret secret) async {
    _secrets.remove(secret);
    await _save();

    notifyListeners();
  }

  ClientSecret get(String instance) {
    if (_secrets.any((cs) => cs.instance.equalsIgnoreCase(instance)))
      return _secrets.firstWhere((cs) => cs.instance.equalsIgnoreCase(instance));

    return null;
  }

  Future<void> _save() async {
    var jsonList = _secrets.map((s) => s.toJson()).toList();
    var json = jsonEncode(jsonList);
    await _preferences.setString("clientSecrets", json);
  }
}