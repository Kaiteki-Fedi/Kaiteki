import 'dart:convert';

import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/repositories/secret_storages/secret_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesSecureStorage extends SecretStorage {
  static const String _accountKey = "accounts";
  static const String _clientKey = "clientSecrets";

  final SharedPreferences _preferences;

  SharedPreferencesSecureStorage(this._preferences);

  @override
  Future<AccountSecret> fetchAccountSecret(
    String username,
    String instance,
  ) async {
    var secrets = await fetchAccountSecrets();
    return secrets
        .firstWhere((s) => s.username == username && s.instance == instance);
  }

  @override
  Future<ClientSecret> fetchClientSecret(String instance) async {
    var secrets = await fetchClientSecrets();
    return secrets.firstWhere((s) => s.instance == instance);
  }

  @override
  Future<void> saveAccountSecret(AccountSecret secret) async {
    var accounts = await fetchAccountSecrets();
    var newList = accounts
        .where((s) => s != secret) // avoid duplicates, prefer updated
        .followedBy([secret]) // add additional secret
        .map((m) => m.toJson()) // convert to JSON maps
        .map(jsonEncode) // convert to JSON strings
        .toList(); // Turn into a pure list

    await _preferences.setStringList(_accountKey, newList);
  }

  @override
  Future<void> saveClientSecret(ClientSecret secret) async {
    var accounts = await fetchClientSecrets();
    var newList = accounts
        .where((s) => s != secret) // avoid duplicates, prefer updated
        .followedBy([secret]) // add additional secret
        .map((m) => m.toJson()) // convert to JSON maps
        .map(jsonEncode) // convert to JSON strings
        .toList(); // Turn into a pure list

    await _preferences.setStringList(_clientKey, newList);
  }

  @override
  Future<Iterable<AccountSecret>> fetchAccountSecrets() async {
    Iterable<String>? strings;

    try {
      strings = _preferences.getStringList(_accountKey);
    } catch (e) {}

    if (strings == null) {
      // We end here because we have no data to transform.
      // We let the code continue with an empty state,
      // in an attempt to let the data be overwritten.
      return [];
    }

    var maps = strings.map(jsonDecode);
    var secrets = maps.map((m) => AccountSecret.fromJson(m));
    return secrets;
  }

  @override
  Future<Iterable<ClientSecret>> fetchClientSecrets() async {
    Iterable<String>? strings;

    try {
      strings = _preferences.getStringList(_clientKey);
    } catch (e) {}

    if (strings == null) {
      // We end here because we have no data to transform.
      // We let the code continue with an empty state,
      // in an attempt to let the data be overwritten.
      return [];
    }

    var maps = strings.map(jsonDecode);
    var secrets = maps.map((m) => ClientSecret.fromJson(m));
    return secrets;
  }

  @override
  Future<void> deleteAccountSecret(AccountSecret accountSecret) {
    // TODO: implement deleteAccountSecret
    throw UnimplementedError();
  }

  @override
  Future<void> deleteClientSecret(ClientSecret clientSecret) {
    // TODO: implement deleteClientSecret
    throw UnimplementedError();
  }
}
