import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/repositories/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kaiteki/utils/extensions/string.dart';
import 'package:kaiteki/utils/extensions/iterable.dart';

class ClientSecretRepository extends ChangeNotifier
    implements Repository<ClientSecret> {
  static const String _preferencesKey = "clientSecrets";

  List<ClientSecret> _secrets;

  final SharedPreferences _preferences;

  ClientSecretRepository(this._preferences);

  static Future<ClientSecretRepository> getInstance(
      [SharedPreferences preferences]) async {
    if (preferences == null)
      preferences = await SharedPreferences.getInstance();

    var repository = ClientSecretRepository(preferences);
    return await repository._initialize();
  }

  Future<ClientSecretRepository> _initialize() async {
    var json = _preferences.getString(_preferencesKey);

    if (json == null) {
      _secrets = <ClientSecret>[];
      return this;
    }

    var accountsJson = jsonDecode(json);
    var accounts =
        accountsJson.map<ClientSecret>((json) => ClientSecret.fromJson(json));
    _secrets = accounts.toList();

    return this;
  }

  @override
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

  @override
  Future<void> remove(ClientSecret secret) async {
    _secrets.remove(secret);
    await _save();

    notifyListeners();
  }

  ClientSecret get(String instance) =>
      _secrets.firstOrDefault((s) => s.instance.equalsIgnoreCase(instance));

  Future<void> _save() async {
    var jsonList = _secrets.map((s) => s.toJson()).toList();
    var json = jsonEncode(jsonList);
    await _preferences.setString(_preferencesKey, json);
  }

  @override
  Iterable<ClientSecret> getAll() => List.unmodifiable(_secrets);

  @override
  void removeAll() {
    // TODO: implement removeAll
  }
}
