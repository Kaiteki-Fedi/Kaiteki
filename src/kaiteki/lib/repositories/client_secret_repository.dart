import 'package:flutter/foundation.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/repositories/repository.dart';
import 'package:kaiteki/repositories/secret_storages/secret_storage.dart';
import 'package:kaiteki/utils/extensions/iterable.dart';
import 'package:kaiteki/utils/extensions/string.dart';

class ClientSecretRepository extends ChangeNotifier
    implements Repository<ClientSecret> {
  late final List<ClientSecret> _secrets;
  final SecretStorage _storage;

  ClientSecretRepository(this._storage);

  @override
  Future<void> insert(ClientSecret secret) async {
    if (_secrets.contains(secret)) {
      throw Exception("Client secret is already present in repository");
    }

    _storage.saveClientSecret(secret);
    notifyListeners();
  }

  @override
  Future<void> remove(ClientSecret secret) async {
    if (!_secrets.contains(secret)) {
      throw Exception("Client secret doesn't exist in repository");
    }

    _storage.deleteClientSecret(secret);
    notifyListeners();
  }

  ClientSecret? get(String instance) {
    return _secrets.firstOrDefault((secret) {
      return secret.instance.equalsIgnoreCase(instance);
    });
  }

  @override
  Iterable<ClientSecret> getAll() {
    return List.unmodifiable(_secrets);
  }

  @override
  void removeAll() {
    // TODO implement removeAll
    throw UnimplementedError();
  }

  @override
  Future<void> initialize() async {
    var clientSecrets = await _storage.fetchClientSecrets();
    _secrets = clientSecrets.toList();
  }
}
