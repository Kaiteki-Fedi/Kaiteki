import "package:flutter/widgets.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/routing/router.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "notifier.g.dart";

@riverpod
class RouterNotifier extends _$RouterNotifier implements Listenable {
  VoidCallback? _routerListener;

  @override
  AccountKey? build() {
    final key = ref.watch(accountProvider)!.key;

    ref.listenSelf((_, __) => _routerListener?.call());

    return key;
  }

  /// Redirects the user when our authentication state changes
  String? redirect(BuildContext context, GoRouterState state) {
    if (state.fullPath?.startsWith(authenticatedPath) == true) {
      if (this.state == null) return "/welcome";
    }
    return null;
  }

  @override
  void addListener(VoidCallback listener) => _routerListener = listener;

  @override
  void removeListener(VoidCallback listener) => _routerListener = null;
}
