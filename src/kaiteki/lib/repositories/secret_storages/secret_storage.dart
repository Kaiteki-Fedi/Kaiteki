import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/client_secret.dart';

abstract class SecretStorage {
  Future<void> saveAccountSecret(AccountSecret secret);
  Future<void> saveClientSecret(ClientSecret secret);

  Future<AccountSecret> fetchAccountSecret(String username, String instance);
  Future<ClientSecret> fetchClientSecret(String instance);

  Future<Iterable<AccountSecret>> fetchAccountSecrets();
  Future<Iterable<ClientSecret>> fetchClientSecrets();

  Future<void> deleteAccountSecret(AccountSecret accountSecret);
  Future<void> deleteClientSecret(ClientSecret clientSecret);
}
