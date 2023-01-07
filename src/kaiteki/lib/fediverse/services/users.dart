import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/model/user/user.dart';
import 'package:kaiteki/model/auth/account_key.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users.g.dart';

@Riverpod(keepAlive: true)
class UsersService extends _$UsersService {
  late BackendAdapter _backend;

  @override
  FutureOr<User> build(AccountKey key, String id) async {
    final manager = ref.read(accountManagerProvider);
    _backend = manager.accounts.firstWhere((a) => a.key == key).adapter;
    return await _backend.getUser(id);
  }
}
