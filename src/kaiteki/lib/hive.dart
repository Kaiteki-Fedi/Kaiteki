import "dart:io";

import "package:flutter/foundation.dart";
import "package:hive/hive.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/model/auth/secret.dart";
import "package:kaiteki/repositories/hive_repository.dart";
import "package:path/path.dart" as path;
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

Future<bool> migrateBoxes() async {
  const boxNames = [
    ("accountsecrets", "account-secrets"),
    ("clientsecrets", "client-secrets"),
  ];

  final documents = await getApplicationDocumentsDirectory();
  final appSupport = await getApplicationSupportDirectory();

  var boxMigrated = false;

  // tampering with FS is probably not possible here
  if (Platform.isAndroid || Platform.isIOS) {
    Future<void> migrateBox<T>(Box<T> from, Box<T> to) async {
      for (final key in from.keys) {
        await to.put(key, from.get(key) as T);
        await from.delete(key);
      }

      await to.close();

      assert(from.isEmpty);
      await from.close();
      await Hive.deleteBoxFromDisk(from.name);
    }

    for (final (from, to) in boxNames) {
      final boxExists = await Hive.boxExists(from, path: documents.path);
      if (!boxExists) continue;

      final fromBox = await Hive.openBox(from, path: documents.path);
      final toBox = await Hive.openBox(to, path: appSupport.path);
      await migrateBox(fromBox, toBox);

      boxMigrated = true;
    }

    return boxMigrated;
  }

  for (final (sourceName, destinationName) in boxNames) {
    for (final ext in [".hive", ".lock"]) {
      final sourcePath = path.join(documents.path, "$sourceName$ext");
      final destinationPath =
          path.join(appSupport.path, "$destinationName$ext");

      final file = File(sourcePath);

      if (await file.exists()) {
        await file.rename(destinationPath);
        boxMigrated = true;
      }
    }
  }

  return boxMigrated;
}

void registerAdapters() {
  Hive
    ..registerAdapter(AccountKeyAdapter())
    ..registerAdapter(ClientSecretAdapter())
    ..registerAdapter(AccountSecretAdapter());
}

String toHive(AccountKey k) => k.toUri().toString();
