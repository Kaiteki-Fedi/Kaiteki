import "package:flutter/widgets.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/model/user/handle.dart";
import "package:kaiteki/routing/router.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "notifier.g.dart";

@riverpod
class RouterNotifier extends _$RouterNotifier implements Listenable {
  VoidCallback? _routerListener;

  @override
  bool build() {
    final isLoggedIn = ref.watch(
      accountProvider.select((value) => value != null),
    );

    ref.listenSelf((_, __) => _routerListener?.call());

    return isLoggedIn;
  }

  UserHandle get currentHandle {
    final key = ref.read(accountProvider)!.key;
    return UserHandle(key.username, key.host);
  }

  /// Redirects the user when our authentication state changes
  String? redirect(BuildContext context, GoRouterState state) {
    if (state.fullpath?.startsWith(authenticatedPath) == true) {
      if (!this.state) return "/welcome";
    }
    return null;
  }

  @override
  void addListener(VoidCallback listener) => _routerListener = listener;

  @override
  void removeListener(VoidCallback listener) => _routerListener = null;
}
