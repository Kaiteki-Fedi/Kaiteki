import 'dart:convert';

import 'package:kaiteki/logger.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/repositories/secret_storages/secret_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesClientSecretStorage extends ClientSecretStorage {
  static const String _clientKey = "clientSecrets";

  final _logger = getLogger('SharedPreferencesSecureStorage');

  final SharedPreferences _preferences;

  SharedPreferencesClientSecretStorage(this._preferences);

  @override
  Future<ClientSecret> get(String instance) async {
    final secrets = await values;
    return secrets.firstWhere((s) => s.instance == instance);
  }

  @override
  Future<void> save(ClientSecret secret) async {
    final accounts = await values;
    final newList = accounts
        .where((s) => s != secret) // avoid duplicates, prefer updated
        .followedBy([secret]) // add additional secret
        .map((m) => m.toJson()) // convert to JSON maps
        .map(jsonEncode) // convert to JSON strings
        .toList(); // Turn into a pure list

    await _preferences.setStringList(_clientKey, newList);
  }

  @override
  Future<Iterable<ClientSecret>> get values async {
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

    final maps = strings.map(jsonDecode).cast<Map<String, dynamic>>();
    final secrets = maps.map(ClientSecret.fromJson);
    return secrets;
  }

  @override
  Future<void> delete(ClientSecret secret) async {
    final accounts = await values;
    final newList = accounts
        .where((s) => s == secret)
        .map((m) => m.toJson()) // convert to JSON maps
        .map(jsonEncode) // convert to JSON strings
        .toList(); // Turn into a pure list

    await _preferences.setStringList(_clientKey, newList);
  }

  @override
  Future<bool> has(String instance) async {
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
    return maps.any((json) {
      final secret = ClientSecret.fromJson(json);
      return secret.instance == instance;
    });
  }
}

class SharedPreferencesAccountSecretStorage extends AccountSecretStorage {
  static const String _key = "accounts";

  final _logger = getLogger('SharedPreferencesAccountSecretStorage');

  final SharedPreferences _preferences;

  SharedPreferencesAccountSecretStorage(this._preferences);

  @override
  Future<AccountSecret> get(String instance, String username) async {
    final secrets = await values;
    return secrets.firstWhere((s) {
      return s.username == username && s.instance == instance;
    });
  }

  @override
  Future<void> save(AccountSecret secret) async {
    final accounts = await values;
    final newList = accounts
        .where((s) => s != secret) // avoid duplicates, prefer updated
        .followedBy([secret]) // add additional secret
        .map((m) => m.toJson()) // convert to JSON maps
        .map(jsonEncode) // convert to JSON strings
        .toList(); // Turn into a pure list

    await _preferences.setStringList(_key, newList);
  }

  @override
  Future<Iterable<AccountSecret>> get values async {
    Iterable<String>? strings;

    try {
      strings = _preferences.getStringList(_key);
    } catch (e) {
      _logger.w("Failed to retrieve account secrets", e);
    }

    if (strings == null) {
      // We end here because we have no data to transform.
      // We let the code continue with an empty state,
      // in an attempt to let the data be overwritten.
      return [];
    }

    final maps = strings.map(jsonDecode).cast<Map<String, dynamic>>();
    final secrets = maps.map(AccountSecret.fromJson);
    return secrets;
  }

  @override
  Future<void> delete(AccountSecret accountSecret) async {
    final accounts = await values;
    final newList = accounts
        .where((s) => s != accountSecret)
        .map((m) => m.toJson()) // convert to JSON maps
        .map(jsonEncode) // convert to JSON strings
        .toList(); // Turn into a pure list

    await _preferences.setStringList(_key, newList);
  }

  @override
  Future<bool> has(String instance, String username) async {
    Iterable<String>? strings;

    try {
      strings = _preferences.getStringList(_key);
    } catch (e) {
      _logger.w("Failed to retrieve account secrets", e);
    }

    if (strings == null) {
      return false;
    }

    final maps = strings.map(jsonDecode);
    return maps.any((m) {
      final secret = AccountSecret.fromJson(m);
      return secret.instance == instance && secret.username == username;
    });
  }
}
