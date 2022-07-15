import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/client_secret.dart';

abstract class Storage<T> {
  Future<Iterable<T>> get values;
  Future<void> save(T value);
  Future<void> delete(T value);
}

abstract class AccountSecretStorage implements Storage<AccountSecret> {
  Future<AccountSecret> get(String instance, String username);
  Future<bool> has(String instance, String username);
}

abstract class ClientSecretStorage implements Storage<ClientSecret> {
  Future<ClientSecret> get(String instance);
  Future<bool> has(String instance);
}
