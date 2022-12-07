import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';
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
import 'package:kaiteki/ui/user/user_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: "/about", builder: (_, __) => const AboutScreen()),
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
    GoRoute(path: "/login", builder: (_, __) => const LoginScreen()),
    GoRoute(path: "/credits", builder: (_, __) => const CreditsScreen()),
    GoRoute(
      path: "/discover-instances",
      builder: (_, __) => const DiscoverInstancesScreen(),
    ),
    ShellRoute(
      builder: _authenticatedBuilder,
      routes: [
        GoRoute(path: "/", builder: _buildMainRoute),
        GoRoute(
          name: "authenticated",
          path: "/@:accountUsername@:accountHost",
          builder: (_, __) => const MainScreen(),
          routes: [
            GoRoute(path: "home", builder: (_, __) => const MainScreen()),
            GoRoute(
              name: "search",
              path: "search",
              builder: (_, __) => const SearchScreen(),
            ),
            GoRoute(
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

Widget _buildMainRoute(BuildContext context, state) {
  return Consumer(
    builder: (context, ref, child) {
      return ref.watch(accountProvider).loggedIn
          ? const MainScreen()
          : const AccountRequiredScreen();
    },
  );
}

Widget _authenticatedBuilder(context, state, child) {
  return Consumer(
    child: child,
    builder: (context, ref, child) {
      final BackendAdapter? adapter;

      final user = state.params["accountUsername"];
      final host = state.params["accountHost"];

      if (user != null && host != null) {
        adapter = ref.watch(
          accountProvider.select(
            (manager) => manager.accounts
                .firstWhere(
                  (account) =>
                      account.key.username == user && account.key.host == host,
                )
                .adapter,
          ),
        );
      } else {
        final accountManager = ref.watch(accountProvider);
        adapter = accountManager.loggedIn //
            ? accountManager.current.adapter
            : null;
      }
      if (adapter != null) {
        return ProviderScope(
          overrides: [adapterProvider.overrideWithValue(adapter)],
          child: child!,
        );
      } else {
        return child!;
      }
    },
  );
}
