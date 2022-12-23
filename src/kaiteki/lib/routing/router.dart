import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/model.dart';
import 'package:kaiteki/model/auth/account.dart';
import 'package:kaiteki/routing/notifier.dart';
import 'package:kaiteki/ui/account_required_screen.dart';
import 'package:kaiteki/ui/auth/discover_instances/discover_instances_screen.dart';
import 'package:kaiteki/ui/auth/login/login_screen.dart';
import 'package:kaiteki/ui/main/main_screen.dart';
import 'package:kaiteki/ui/search/screen.dart';
import 'package:kaiteki/ui/settings/about/about_screen.dart';
import 'package:kaiteki/ui/settings/credits_screen.dart';
import 'package:kaiteki/ui/settings/customization/customization_settings_screen.dart';
import 'package:kaiteki/ui/settings/debug/theme_screen.dart';
import 'package:kaiteki/ui/settings/debug_screen.dart';
import 'package:kaiteki/ui/settings/experiments.dart';
import 'package:kaiteki/ui/settings/settings_screen.dart';
import 'package:kaiteki/ui/shared/conversation_screen.dart';
import 'package:kaiteki/ui/shared/dialogs/account_list_dialog.dart';
import 'package:kaiteki/ui/user/user_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "root");
final GlobalKey<NavigatorState> _authNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "authenticated");

const authenticatedPath = "/@:accountUsername@:accountHost";

final routerProvider = Provider.autoDispose<GoRouter>((ref) {
  final sub = ref.listen(routerNotifierProvider, (_, __) {});
  ref.onDispose(sub.close);

  final notifier = ref.read(routerNotifierProvider.notifier);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(
        path: "/",
        builder: (_, __) => const SizedBox(),
        redirect: (context, state) {
          final scope = ProviderScope.containerOf(context);
          final isLoggedIn = scope.read(accountManagerProvider).loggedIn;
          if (!isLoggedIn) return "/welcome";

          return "/${notifier.currentHandle}/home";
        },
      ),
      GoRoute(
        path: "/welcome",
        builder: (_, __) => const AccountRequiredScreen(),
      ),
      GoRoute(
        path: "/about",
        builder: (_, __) => const AboutScreen(),
      ),
      GoRoute(
        name: "accounts",
        path: "/accounts",
        pageBuilder: (context, state) {
          return _DialogPage(
            builder: (context) => const AccountListDialog(),
          );
        },
      ),
      GoRoute(
        path: "/settings",
        builder: (_, __) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: "customization",
            builder: (_, __) => const CustomizationSettingsScreen(),
          ),
          GoRoute(
            name: "experiments",
            path: "experiments",
            builder: (_, __) => const ExperimentsScreen(),
          ),
          GoRoute(
            path: "debug",
            builder: (_, __) => const DebugScreen(),
            routes: [
              GoRoute(
                path: "theme",
                builder: (_, __) => const ThemeScreen(),
              )
            ],
          ),
        ],
      ),
      GoRoute(
        path: "/login",
        builder: (_, __) => const LoginScreen(),
        parentNavigatorKey: _rootNavigatorKey,
      ),
      GoRoute(
        path: "/credits",
        builder: (_, __) => const CreditsScreen(),
        parentNavigatorKey: _rootNavigatorKey,
      ),
      GoRoute(
        path: "/discover-instances",
        builder: (_, __) => const DiscoverInstancesScreen(),
        parentNavigatorKey: _rootNavigatorKey,
      ),
      GoRoute(
        name: "authenticated",
        path: authenticatedPath,
        builder: (_, __) => const SizedBox(),
        redirect: (context, state) {
          if (state.fullpath == authenticatedPath) {
            return "${state.location}/home";
          }
          return null;
        },
        routes: [
          ShellRoute(
            navigatorKey: _authNavigatorKey,
            builder: _authenticatedBuilder,
            routes: [
              GoRoute(
                name: "home",
                path: "home",
                builder: (_, __) => const MainScreen(),
              ),
              GoRoute(
                name: "search",
                path: "search",
                // parentNavigatorKey: _authNavigatorKey,
                builder: (_, __) => const SearchScreen(),
              ),
              GoRoute(
                name: "user",
                // parentNavigatorKey: _authNavigatorKey,
                path: "users/:id",
                builder: (context, state) {
                  if (state.extra == null) {
                    return UserScreen.fromId(state.params["id"]!);
                  } else {
                    return UserScreen.fromUser(state.extra! as User);
                  }
                },
              ),
              GoRoute(
                name: "post",
                // parentNavigatorKey: _authNavigatorKey,
                path: "posts/:id",
                builder: (context, state) {
                  return ConversationScreen(state.extra! as Post);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

Widget _authenticatedBuilder(context, state, child) {
  return Consumer(
    child: child,
    builder: (context, ref, child) {
      final Account? account;

      final user = state.params["accountUsername"];
      final host = state.params["accountHost"];

      if (user != null && host != null) {
        account = ref.watch(
          accountManagerProvider.select(
            (manager) => manager.accounts.firstWhere(
              (account) =>
                  account.key.username == user && account.key.host == host,
            ),
          ),
        );
      } else {
        account = ref.watch(accountProvider);
      }

      if (account != null) {
        return ProviderScope(
          overrides: [
            adapterProvider.overrideWithValue(account.adapter),
            accountProvider.overrideWithValue(account),
          ],
          child: child!,
        );
      } else {
        return child!;
      }
    },
  );
}

class _DialogPage extends Page {
  final WidgetBuilder builder;

  const _DialogPage({
    required this.builder,
  });

  @override
  Route createRoute(BuildContext context) {
    return DialogRoute(
      builder: builder,
      context: context,
      settings: this,
    );
  }
}
