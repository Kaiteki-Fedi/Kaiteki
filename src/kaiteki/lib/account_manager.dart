import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:kaiteki/exceptions/instance_unreachable_exception.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/model/instance.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/logger.dart';
import 'package:kaiteki/model/auth/account_compound.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/repositories/account_secret_repository.dart';
import 'package:kaiteki/repositories/client_secret_repository.dart';

class AccountManager extends ChangeNotifier {
  static final _logger = getLogger('AccountContainer');

  AccountCompound? _currentAccount;
  AccountCompound get currentAccount => _currentAccount!;

  String get instance => currentAccount.clientSecret.instance;
  FediverseAdapter get adapter => currentAccount.adapter;
  bool get loggedIn => _currentAccount != null;

  final AccountSecretRepository _accountSecrets;
  final ClientSecretRepository _clientSecrets;

  final List<AccountCompound> _accounts = <AccountCompound>[];
  Iterable<AccountCompound> get accounts => List.unmodifiable(_accounts);

  AccountManager(this._accountSecrets, this._clientSecrets);

  Future<void> remove(AccountCompound compound) async {
    _accounts.remove(compound);
    await _accountSecrets.remove(compound.accountSecret);
    await _clientSecrets.remove(compound.clientSecret);

    notifyListeners();

    _logger.d('Removed account ${compound.instance}');
  }

  Future<void> addCurrentAccount(AccountCompound compound) async {
    if (contains(compound)) {
      throw Exception(
        'Cannot add an account with the same instance and username',
      );
    }

    _accounts.add(compound);
    _accountSecrets.insert(compound.accountSecret);

    if (!await _clientSecrets.contains(compound.clientSecret)) {
      _clientSecrets.insert(compound.clientSecret);
    }

    await changeAccount(compound);
  }

  bool contains(AccountCompound account) {
    for (final otherAccount in _accounts) {
      if (otherAccount == account) return true;
    }

    return false;
  }

  Future<void> changeAccount(AccountCompound account) async {
    assert(_accounts.contains(account));

    _currentAccount = account;

    notifyListeners();
  }

  Future<void> loadAllAccounts() async {
    _accounts.clear();

    final secrets = _accountSecrets.getAll();
    await Future.forEach(secrets, _restoreSession);

    if (_accounts.isNotEmpty) {
      // TODO(Craftplacer): Store which account the user last used
      await changeAccount(_accounts.first);
    }
  }

  Future<void> _restoreSession(AccountSecret accountSecret) async {
    final instance = accountSecret.instance;
    final clientSecret = _clientSecrets.get(instance)!;

    if (clientSecret.apiType == null) {
      _logger.d("Client secret didn't have contain API type.");
      return;
    }

    _logger.d('Trying to recover a ${clientSecret.apiType} account');

    final adapter = clientSecret.apiType!.createAdapter();
    await adapter.client.setClientAuthentication(clientSecret);
    await adapter.client.setAccountAuthentication(accountSecret);

    // restoring user object
    User? user;
    try {
      user = await adapter.getMyself();
    } catch (ex) {
      _logger.e('Failed to verify credentials', ex);
    }

    if (user == null) {
      _logger.w('No user data was recovered, assuming user info is incorrect.');
      return;
    }

    final compound = AccountCompound(
      container: this,
      adapter: adapter,
      account: user,
      clientSecret: clientSecret,
      accountSecret: accountSecret,
    );

    _accounts.add(compound);

    _logger.d(
      'Recovered ${compound.account.displayName} @ ${compound.clientSecret.instance}',
    );
  }

  Future<InstanceProbeResult> probeInstance(String instance) async {
    final isInstanceAvailable = await _checkInstanceAvailability(instance);
    if (!isInstanceAvailable) {
      throw InstanceUnreachableException();
    }

    for (final apiType in ApiType.values) {
      try {
        final adapter = apiType.createAdapter();
        adapter.client.instance = instance;

        _logger.d('Probing for ${apiType.displayName} on $instance...');

        final result = await adapter.probeInstance();

        if (result != null) {
          _logger.d('Detected ${apiType.displayName} on $instance');
          return InstanceProbeResult.successful(apiType, result);
        }
      } catch (_) {
        continue;
      }
    }

    _logger.d("Couldn't detect backend on on $instance");
    return const InstanceProbeResult.failed();
  }

  Future<bool> _checkInstanceAvailability(String instance) async {
    final uri = Uri.https(instance, '');

    try {
      final response = await http.get(uri);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // TODO(Craftplacer): HACK, This should not exist, please refactor.
  ClientSecretRepository getClientRepo() => _clientSecrets;
}

class InstanceProbeResult {
  final ApiType? type;
  final Instance? instance;
  final bool successful;

  const InstanceProbeResult.successful(
    this.type,
    this.instance,
  ) : successful = true;

  const InstanceProbeResult.failed()
      : successful = false,
        type = null,
        instance = null;
}
