import "package:kaiteki/account_manager.dart";

import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki_core/social.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "users.g.dart";

@Riverpod(keepAlive: true)
class UsersService extends _$UsersService {
  late BackendAdapter _backend;

  @override
  FutureOr<User?> build(AccountKey key, String id) async {
    _backend = ref
        .read(accountManagerProvider)
        .accounts
        .firstWhere((a) => a.key == key)
        .adapter;
    return await _backend.getUser(id);
  }
}
