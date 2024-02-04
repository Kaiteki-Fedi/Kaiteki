import "package:kaiteki/account_manager.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:logging/logging.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "user_resolver.g.dart";

final _logger = Logger("User Resolver");

@riverpod
Future<ResolveUserResult?> resolve(
  ResolveRef ref,
  AccountKey key,
  UserReference reference,
) async {
  final account =
      ref.read(accountManagerProvider).accounts.firstWhere((a) => a.key == key);
  return reference.resolve(account.adapter);
}

extension UserReferenceExtensions on UserReference {
  Future<ResolveUserResult?> resolve(BackendAdapter adapter) async {
    _logger.finest("Resolving user: $this");

    final id = this.id;
    if (id != null) {
      return adapter
          .getUserById(id)
          .then((e) => e == null ? null : ResolvedInternalUser(e));
    }

    final username = this.username;
    final host = this.host;
    if (username != null) {
      try {
        final user = await adapter.lookupUser(username, host);
        return ResolvedInternalUser(user);
      } catch (e, s) {
        _logger.warning("Failed to resolve user by username", e, s);
      }
    }

    final urlString = remoteUrl;
    if (urlString != null) {
      final url = Uri.parse(urlString);

      try {
        final entity = await adapter.resolveUrl(url);
        if (entity is User) return ResolvedInternalUser(entity);
      } catch (e, s) {
        _logger.warning("Failed to resolve user by URL", e, s);
      }

      return ResolvedExternalUser(url);
    }

    return null;
  }
}

sealed class ResolveUserResult {
  const ResolveUserResult();
}

/// The user was able to be found on the local instance.
class ResolvedInternalUser extends ResolveUserResult {
  final User user;

  const ResolvedInternalUser(this.user);
}

/// The user couldn't be found on the local instance, but a URL linking to the
/// user was found instead.
class ResolvedExternalUser extends ResolveUserResult {
  final Uri url;

  const ResolvedExternalUser(this.url);
}
