import 'package:flutter/foundation.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/repositories/repository.dart';
import 'package:kaiteki/repositories/secret_storages/secret_storage.dart';
import 'package:kaiteki/utils/extensions/iterable.dart';
import 'package:kaiteki/utils/extensions/string.dart';

class AccountSecretRepository extends ChangeNotifier
    implements Repository<AccountSecret> {
  late final List<AccountSecret> _secrets;
  final SecretStorage _storage;

  AccountSecretRepository(this._storage);

  @override
  Future<void> insert(AccountSecret secret) async {
    if (_secrets.contains(secret)) {
      throw Exception("Account secret is already present in repository");
    }

    await _storage.saveAccountSecret(secret);
    notifyListeners();
  }

  @override
  Future<void> remove(AccountSecret secret) async {
    if (!_secrets.contains(secret)) {
      throw Exception("Account secret doesn't exist in repository");
    }

    await _storage.deleteAccountSecret(secret);
    notifyListeners();
  }

  AccountSecret? get(String username, String instance) {
    return _secrets.firstOrDefault((secret) {
      return secret.instance.equalsIgnoreCase(instance) &&
          secret.username.equalsIgnoreCase(username);
    });
  }

  @override
  Iterable<AccountSecret> getAll() {
    return List.unmodifiable(_secrets);
  }

  @override
  void removeAll() {
    // TODO(Craftplacer): implement removeAll
    throw UnimplementedError();
  }

  @override
  Future<void> initialize() async {
    final accountSecrets = await _storage.fetchAccountSecrets();
    _secrets = accountSecrets.toList();
  }

  @override
  Future<bool> contains(AccountSecret secret) async {
    return _storage.hasAccountSecret(secret);
  }
}
