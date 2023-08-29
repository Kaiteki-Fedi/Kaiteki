import "package:kaiteki/account_manager.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:logging/logging.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "user_resolver.g.dart";

@riverpod
Future<User?> resolve(
  ResolveRef ref,
  AccountKey key,
  UserReference reference,
) async {
  final account =
      ref.read(accountManagerProvider).accounts.firstWhere((a) => a.key == key);
  return reference.resolve(account.adapter);
}

extension UserReferenceExtensions on UserReference {
  Future<User?> resolve(BackendAdapter adapter) async {
    Logger("resolve").finest("Resolving user: $this");

    final id = this.id;
    if (id != null) {
      return adapter.getUserById(id);
    }

    final username = this.username;
    if (username != null) {
      return adapter.lookupUser(username, host);
    }

    final url = remoteUrl;
    if (url != null) {
      final entity = await adapter.resolveUrl(Uri.parse(url));
      if (entity is User) return entity;
    }

    return null;
  }
}
