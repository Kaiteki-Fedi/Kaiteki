import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/theming/app_themes/default_app_themes.dart';
import 'package:kaiteki/ui/screens.dart';
import 'package:kaiteki/ui/screens/conversation_screen.dart';
import 'package:kaiteki/ui/screens/user_screen.dart';

class KaitekiApp extends ConsumerWidget {
  late final GoRouter _router = GoRouter(
    navigatorBuilder: _buildNavigator,
    routes: [
      GoRoute(path: "/", builder: _buildMainRoute),
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
            path: "filtering",
            builder: (_, __) => const FilteringScreen(),
            routes: [
              GoRoute(
                path: "sensitivePosts",
                builder: (_, __) => const SensitivePostFilteringScreen(),
              ),
            ],
          ),
          GoRoute(
            path: "debug",
            builder: (_, __) => const DebugScreen(),
            routes: [
              GoRoute(
                path: "preferences",
                builder: (_, __) => const SharedPreferencesScreen(),
              ),
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
      GoRoute(
        name: "authenticated",
        path: "/@:accountUsername@:accountHost",
        builder: (_, __) => const MainScreen(),
        routes: [
          GoRoute(path: "home", builder: (_, __) => const MainScreen()),
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
  );

  Widget _buildNavigator(context, state, child) {
    return Consumer(
      child: child,
      builder: (context, ref, child) {
        final FediverseAdapter? adapter;

        final user = state.params["accountUsername"];
        final host = state.params["accountHost"];

        if (user != null && host != null) {
          adapter = ref.watch(
            accountProvider.select((value) {
              return value.accounts.firstWhere((a) {
                return a.matchesHandle("@$user@$host");
              }).adapter;
            }),
          );
        } else {
          final accountManager = ref.watch(accountProvider);
          adapter = accountManager.loggedIn ? accountManager.adapter : null;
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

  KaitekiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(Craftplacer): (code quality) listen to only a subset of preferences, to reduce unnecessary root rebuilds.
    final preferences = ref.watch(preferenceProvider);
    return MaterialApp.router(
      darkTheme: ThemeData.from(colorScheme: darkScheme),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData.from(colorScheme: lightScheme),
      themeMode: preferences.get().theme,
      title: consts.appName,
    );
  }

  Widget _buildMainRoute(BuildContext context, state) {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(accountProvider).loggedIn
            ? const MainScreen()
            : const AccountRequiredScreen();
      },
    );
  }
}
