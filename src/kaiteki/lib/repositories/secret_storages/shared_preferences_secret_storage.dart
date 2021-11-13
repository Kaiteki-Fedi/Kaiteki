import 'dart:convert';

import 'package:kaiteki/logger.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/repositories/secret_storages/secret_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesSecureStorage extends SecretStorage {
  static const String _accountKey = "accounts";
  static const String _clientKey = "clientSecrets";

  final _logger = getLogger('SharedPreferencesSecureStorage');

  final SharedPreferences _preferences;

  SharedPreferencesSecureStorage(this._preferences);

  @override
  Future<AccountSecret> fetchAccountSecret(
    String username,
    String instance,
  ) async {
    final secrets = await fetchAccountSecrets();
    return secrets.firstWhere((s) {
      return s.username == username && s.instance == instance;
    });
  }

  @override
  Future<ClientSecret> fetchClientSecret(String instance) async {
    final secrets = await fetchClientSecrets();
    return secrets.firstWhere((s) => s.instance == instance);
  }

  @override
  Future<void> saveAccountSecret(AccountSecret secret) async {
    final accounts = await fetchAccountSecrets();
    final newList = accounts
        .where((s) => s != secret) // avoid duplicates, prefer updated
        .followedBy([secret]) // add additional secret
        .map((m) => m.toJson()) // convert to JSON maps
        .map(jsonEncode) // convert to JSON strings
        .toList(); // Turn into a pure list

    await _preferences.setStringList(_accountKey, newList);
  }

  @override
  Future<void> saveClientSecret(ClientSecret secret) async {
    final accounts = await fetchClientSecrets();
    final newList = accounts
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
    } catch (e) {
      _logger.w("Failed to retrieve account secrets", e);
    }

    if (strings == null) {
      // We end here because we have no data to transform.
      // We let the code continue with an empty state,
      // in an attempt to let the data be overwritten.
      return [];
    }

    final maps = strings.map(jsonDecode);
    final secrets = maps.map((m) => AccountSecret.fromJson(m));
    return secrets;
  }

  @override
  Future<Iterable<ClientSecret>> fetchClientSecrets() async {
    Iterable<String>? strings;

    try {
      strings = _preferences.getStringList(_clientKey);
    } catch (e) {
      _logger.w("Failed to retrieve client secrets", e);
    }

    if (strings == null) {
      // We end here because we have no data to transform.
      // We let the code continue with an empty state,
      // in an attempt to let the data be overwritten.
      return [];
    }

    final maps = strings.map(jsonDecode);
    final secrets = maps.map((m) => ClientSecret.fromJson(m));
    return secrets;
  }

  @override
  Future<void> deleteAccountSecret(AccountSecret accountSecret) async {
    final accounts = await fetchAccountSecrets();
    final newList = accounts
        .where((s) => s != accountSecret)
        .map((m) => m.toJson()) // convert to JSON maps
        .map(jsonEncode) // convert to JSON strings
        .toList(); // Turn into a pure list

    await _preferences.setStringList(_accountKey, newList);
  }

  @override
  Future<void> deleteClientSecret(ClientSecret clientSecret) async {
    final accounts = await fetchClientSecrets();
    final newList = accounts
        .where((s) => s != clientSecret)
        .map((m) => m.toJson()) // convert to JSON maps
        .map(jsonEncode) // convert to JSON strings
        .toList(); // Turn into a pure list

    await _preferences.setStringList(_clientKey, newList);
  }

  @override
  Future<bool> hasAccountSecret(AccountSecret accountSecret) async {
    Iterable<String>? strings;

    try {
      strings = _preferences.getStringList(_accountKey);
    } catch (e) {
      _logger.w("Failed to retrieve account secrets", e);
    }

    if (strings == null) {
      return false;
    }

    final maps = strings.map(jsonDecode);
    return maps.any((m) {
      return AccountSecret.fromJson(m) == accountSecret;
    });
  }

  @override
  Future<bool> hasClientSecret(ClientSecret clientSecret) async {
    Iterable<String>? strings;

    try {
      strings = _preferences.getStringList(_clientKey);
    } catch (e) {
      _logger.w("Failed to retrieve client secrets", e);
    }

    if (strings == null) {
      return false;
    }

    final maps = strings.map(jsonDecode);
    return maps.any((m) {
      return ClientSecret.fromJson(m) == clientSecret;
    });
  }
}
