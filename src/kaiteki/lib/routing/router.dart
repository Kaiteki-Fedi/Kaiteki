import "dart:developer";

import "package:collection/collection.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/interfaces/favorite_support.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/routing/notifier.dart";
import "package:kaiteki/ui/account/mute_screen.dart";
import "package:kaiteki/ui/account/settings_screen.dart";
import "package:kaiteki/ui/account_required_screen.dart";
import "package:kaiteki/ui/auth/login/login_screen.dart";
import "package:kaiteki/ui/feedback_screen.dart";
import "package:kaiteki/ui/lists/lists_screen.dart";
import "package:kaiteki/ui/main/main_screen.dart";
import "package:kaiteki/ui/search/screen.dart";
import "package:kaiteki/ui/settings/a11y/screen.dart";
import "package:kaiteki/ui/settings/about/about_screen.dart";
import "package:kaiteki/ui/settings/credits_screen.dart";
import "package:kaiteki/ui/settings/customization/customization_settings_screen.dart";
import "package:kaiteki/ui/settings/customization/post_layout.dart";
import "package:kaiteki/ui/settings/debug/theme_screen.dart";
import "package:kaiteki/ui/settings/debug_screen.dart";
import "package:kaiteki/ui/settings/experiments.dart";
import "package:kaiteki/ui/settings/manage_languages.dart";
import "package:kaiteki/ui/settings/pedantry_screen.dart";
import "package:kaiteki/ui/settings/settings_screen.dart";
import "package:kaiteki/ui/settings/wellbeing/wellbeing_screen.dart";
import "package:kaiteki/ui/shared/account_list/dialog.dart";
import "package:kaiteki/ui/shared/conversation_screen.dart";
import "package:kaiteki/ui/shared/posts/compose/compose_screen.dart";
import "package:kaiteki/ui/shared/posts/user_list_dialog.dart";
import "package:kaiteki/ui/user/user_screen.dart";
import "package:kaiteki/utils/extensions.dart";

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "root");
final GlobalKey<NavigatorState> _authNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "authenticated");

const authenticatedPath = "/@:accountUsername@:accountHost";

final routerProvider = Provider.autoDispose<GoRouter>((ref) {
  final account = ref.watch(routerNotifierProvider);

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
          if (account == null) return "/welcome";
          return "/${account.handle}/home";
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
        path: "/send-feedback",
        builder: (_, __) => const FeedbackScreen(),
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
            routes: [
              GoRoute(
                path: "post-layout",
                builder: (_, __) => const PostLayoutSettingsScreen(),
              ),
            ],
          ),
          GoRoute(
            name: "experiments",
            path: "experiments",
            builder: (_, __) => const ExperimentsScreen(),
          ),
          GoRoute(
            name: "wellbeing",
            path: "wellbeing",
            builder: (_, __) => const WellbeingScreen(),
          ),
          GoRoute(
            name: "pedantry",
            path: "pedantry",
            builder: (_, __) => const PedantryScreen(),
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
          GoRoute(
            path: "accessibility",
            builder: (_, __) => const AccessibilityScreen(),
          ),
          GoRoute(
            path: "visible-languages",
            name: "visibleLanguageSettings",
            builder: (_, __) => const ManageLanaguagesScreen(),
          )
        ],
      ),
      GoRoute(
        name: "login",
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
        name: "authenticated",
        path: authenticatedPath,
        builder: (_, __) => const SizedBox(),
        redirect: (context, state) {
          final user = state.pathParameters["accountUsername"];
          final host = state.pathParameters["accountHost"];

          if (user != null && host != null) {
            final account = ref.read(
              accountManagerProvider.select(
                (manager) => manager.accounts.firstWhereOrNull(
                  (account) =>
                      account.key.username == user && account.key.host == host,
                ),
              ),
            );

            if (account == null) {
              log("No account matching to @$user@$host, so no account was switched");
            }

            final accountManager = ref.read(accountManagerProvider);
            final previousAccount = accountManager.current;
            if (previousAccount != account) {
              accountManager.current = account;
              log("Switched from ${previousAccount?.key.handle} to ${account!.key.handle} due to navigation path");
            }
          }

          if (state.fullPath == authenticatedPath) {
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
                name: "compose",
                path: "compose",
                pageBuilder: (context, state) {
                  return _DialogPage(
                    builder: (context) {
                      return ComposeScreen(
                        replyTo: state.extra?.safeCast<Post>(),
                      );
                    },
                  );
                },
              ),
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
                  final id = state.pathParameters["id"]!;
                  return UserScreen(id: id);
                },
              ),
              GoRoute(
                name: "lists",
                path: "lists",
                builder: (_, __) => const ListsScreen(),
              ),
              GoRoute(
                name: "post",
                // parentNavigatorKey: _authNavigatorKey,
                path: "posts/:id",
                builder: (context, state) {
                  final post = state.extra.safeCast<Post>();

                  if (post == null) {
                    context.pop();
                    return const SizedBox();
                  } else {
                    return ConversationScreen(post);
                  }
                },
                routes: [
                  GoRoute(
                    path: "repeats",
                    name: "postRepeats",
                    pageBuilder: (context, state) {
                      return _DialogPage(
                        builder: (context) => Consumer(
                          builder: (context, ref, __) {
                            final postId = state.pathParameters["id"]!;
                            final l10n = context.l10n;
                            final adapter = ref.watch(adapterProvider);
                            return UserListDialog(
                              title: Text(l10n.repeateesTitle),
                              fetchUsers: () async {
                                final users = await adapter.getRepeatees(
                                  postId,
                                );
                                return users;
                              }(),
                              emptyIcon: const Icon(Icons.repeat_rounded),
                              emptyTitle: Text(l10n.repeatsEmpty),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    path: "favorites",
                    name: "postFavorites",
                    pageBuilder: (context, state) {
                      return _DialogPage(
                        builder: (context) => Consumer(
                          builder: (context, ref, __) {
                            final postId = state.pathParameters["id"]!;
                            final l10n = context.l10n;
                            final adapter = ref.watch(adapterProvider);
                            return UserListDialog(
                              title: Text(l10n.favoriteesTitle),
                              fetchUsers: () async {
                                final users = await (adapter as FavoriteSupport)
                                    .getFavoritees(postId);
                                return users;
                              }(),
                              emptyIcon: const Icon(Icons.star_outline_rounded),
                              emptyTitle: Text(l10n.favoritesEmpty),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              GoRoute(
                name: "accountSettings",
                path: "settings",
                builder: (_, __) => const AccountSettingsScreen(),
                routes: [
                  GoRoute(
                    name: "accountMutes",
                    path: "mutes",
                    builder: (_, __) => const MutesScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

Widget _authenticatedBuilder(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return Consumer(
    child: child,
    builder: (context, ref, child) {
      final Account? account;

      final user = state.pathParameters["accountUsername"];
      final host = state.pathParameters["accountHost"];

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
