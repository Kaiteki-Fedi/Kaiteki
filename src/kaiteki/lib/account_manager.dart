import "package:collection/collection.dart";
import "package:flutter/foundation.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/model/auth/secret.dart";
import "package:kaiteki/repositories/repository.dart";
import "package:kaiteki_core/kaiteki_core.dart" hide UserSecret, ClientSecret;
import "package:logging/logging.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "account_manager.g.dart";

typedef AccountManagerState = ({Set<Account> accounts, Account? current});

@Riverpod()
Repository<AccountSecret, AccountKey> accountSecretRepository(_) =>
    throw UnimplementedError();

@Riverpod()
Repository<ClientSecret, AccountKey> clientSecretRepository(_) =>
    throw UnimplementedError();

@Riverpod(
  keepAlive: true,
  dependencies: [accountSecretRepository, clientSecretRepository],
)
class AccountManager extends _$AccountManager {
  static final _logger = Logger("AccountManager");

  void change(Account account) {
    final lastState = state;

    if (lastState.accounts.contains(account)) {
      state = (
        accounts: {...lastState.accounts, account},
        current: account,
      );
    } else {
      state = (
        accounts: lastState.accounts,
        current: account,
      );
    }
  }

  late Repository<AccountSecret, AccountKey> _accountSecrets;
  late Repository<ClientSecret, AccountKey> _clientSecrets;

  /// Removes an account.
  ///
  /// Returns true if the operation succeeded, false if the account was not
  /// found. Throws when the operation fails when trying to persist the changes.
  Future<bool> remove(Account account) async {
    if (!state.accounts.contains(account)) return false;

    await _accountSecrets.delete(account.key);

    if (account.clientSecret != null) {
      await _clientSecrets.delete(account.key);
    }

    final set = state.accounts..remove(account);

    state = (
      accounts: set,
      current: state.current == account ? set.firstOrNull : state.current,
    );

    return true;
  }

  @override
  AccountManagerState build() {
    _accountSecrets = ref.read(accountSecretRepositoryProvider);
    _clientSecrets = ref.read(clientSecretRepositoryProvider);
    return (accounts: {}, current: null);
  }

  Future<void> add(Account account) async {
    final lastState = state;

    if (lastState.accounts.any((e) => e.key == account.key)) {
      throw ArgumentError(
        "An account with the same username and instance already exists",
        "account",
      );
    }

    if (account.accountSecret != null) {
      await _accountSecrets.create(account.key, account.accountSecret!);
    }

    if (account.clientSecret != null) {
      await _clientSecrets.create(account.key, account.clientSecret!);
    }

    final set = {...state.accounts, account};

    state = (
      accounts: set,
      current: state.current ?? set.firstOrNull,
    );
  }

  /// Tries to restore all sessions provided.
  ///
  /// If [priorityAccount] is provided, it attempts to restore that account
  /// first.
  Stream<AccountKey> restoreSessions({AccountKey? priorityAccount}) async* {
    final accountSecrets = await _accountSecrets.read();
    final clientSecrets = await _clientSecrets.read();

    final secretPairs = accountSecrets.entries.map((kv) {
      final clientSecret = clientSecrets[kv.key];
      return (kv.key, kv.value, clientSecret);
    }).toList();

    if (secretPairs.isEmpty) {
      _logger.fine("No accounts signed into");
      return;
    }

    if (priorityAccount != null) {
      final priorityPair = secretPairs.firstWhereOrNull((tuple) {
        return tuple.$1 == priorityAccount;
      });

      if (priorityPair != null) {
        secretPairs
          ..remove(priorityPair)
          ..insert(0, priorityPair);
      }
    }

    for (final tuple in secretPairs) {
      yield tuple.$1;

      final account = await restoreSession(tuple);

      if (account == null) continue;

      _logger.fine("Signed into @${account.user.username}@${account.key.host}");

      await add(account);
    }
  }

  /// Retrieves the client secret for a given instance.
  Future<ClientSecret?> getClientSecret(
    String instance, [
    String? username,
  ]) async {
    final secrets = await _clientSecrets.read();
    final key = secrets.keys.firstWhereOrNull((key) {
      return key.host == instance && key.username == username;
    });
    return secrets[key];
  }

  Future<Account?> restoreSession(
    (AccountKey, AccountSecret, ClientSecret?) credentials,
  ) async {
    final (key, accountSecret, clientSecret) = credentials;
    final type = key.type!;

    _logger.fine("Trying to recover a ${type.displayName} account");

    if (kDebugMode) await Future.delayed(const Duration(seconds: 2));

    BackendAdapter adapter;

    try {
      adapter = await type.createAdapter(key.host);
    } catch (e, s) {
      _logger.warning("Failed to create ${type.adapterType}", e, s);
      return null;
    }

    try {
      await adapter.applySecrets(
        clientSecret.nullTransform((e) => (e.clientId, e.clientSecret)),
        (
          accessToken: accountSecret.accessToken,
          refreshToken: accountSecret.refreshToken,
          userId: accountSecret.userId
        ),
      );
    } catch (e, s) {
      _logger.warning("Failed to apply secrets to ${type.adapterType}", e, s);
      return null;
    }

    User user;

    try {
      user = await adapter.getMyself();
    } catch (e, s) {
      _logger.warning(
        "Failed to fetch user profile of authenticated user",
        e,
        s,
      );
      return null;
    }

    return Account(
      key: key,
      adapter: adapter,
      user: user,
      clientSecret: clientSecret,
      accountSecret: accountSecret,
    );
  }
}
