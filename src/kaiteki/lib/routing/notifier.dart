import "package:flutter/widgets.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/routing/router.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "notifier.g.dart";

@Riverpod(keepAlive: true, dependencies: [AccountManager])
class RouterNotifier extends _$RouterNotifier implements Listenable {
  VoidCallback? _routerListener;

  @override
  AccountKey? build() {
    ref.listenSelf((_, __) => _routerListener?.call());
    return ref.watch(accountManagerProvider.select((e) => e.current?.key));
  }

  /// Redirects the user when our authentication state changes
  String? redirect(BuildContext context, GoRouterState state) {
    final isAuthenticatedPath =
        state.fullPath?.startsWith(authenticatedPath) == true;

    if (!isAuthenticatedPath) return null;

    if (this.state == null) return "/";

    final username = state.pathParameters["accountUsername"];
    final host = state.pathParameters["accountHost"];

    assert(username != null && host != null);

    final accounts = ref.read(accountManagerProvider.select((e) => e.accounts));
    final accountExists =
        accounts.any((e) => e.key.username == username && e.key.host == host);
    if (!accountExists) return "/";

    return null;
  }

  @override
  void addListener(VoidCallback listener) => _routerListener = listener;

  @override
  void removeListener(VoidCallback listener) => _routerListener = null;
}
