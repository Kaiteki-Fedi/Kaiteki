import "package:flutter/foundation.dart";
import "package:hive/hive.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/model/auth/secret.dart";
import "package:kaiteki/repositories/hive_repository.dart";
import "package:path_provider/path_provider.dart";

AccountKey fromHive(dynamic k) => AccountKey.fromUri(k as String);

Future<HiveRepository<AccountSecret, AccountKey>> getAccountRepository() async {
  final accountBox = await Hive.openBox<AccountSecret>("account-secrets");
  return HiveRepository<AccountSecret, AccountKey>(
    accountBox,
    fromHive,
    toHive,
    true,
  );
}

Future<HiveRepository<ClientSecret, AccountKey>> getClientRepository() async {
  final clientBox = await Hive.openBox<ClientSecret>("client-secrets");
  return HiveRepository<ClientSecret, AccountKey>(
    clientBox,
    fromHive,
    toHive,
    true,
  );
}

Future<void> initialize() async {
  String? path;

  if (!kIsWeb) path = (await getApplicationSupportDirectory()).path;

  Hive.init(path);
}

void registerAdapters() {
  Hive
    ..registerAdapter(AccountKeyAdapter())
    ..registerAdapter(ClientSecretAdapter())
    ..registerAdapter(AccountSecretAdapter());
}

String toHive(AccountKey k) => k.toUri().toString();
