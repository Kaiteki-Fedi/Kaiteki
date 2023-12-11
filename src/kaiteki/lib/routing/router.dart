import "package:animations/animations.dart";
import "package:collection/collection.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/auth/oauth.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/routing/notifier.dart";
import "package:kaiteki/ui/account/mute_screen.dart";
import "package:kaiteki/ui/account/settings_screen.dart";
import "package:kaiteki/ui/announcements/dialog.dart";
import "package:kaiteki/ui/auth/login/login_screen.dart";
import "package:kaiteki/ui/auth/oauth_finalization_screen.dart";
import "package:kaiteki/ui/feedback_screen.dart";
import "package:kaiteki/ui/follow_requests/dialog.dart";
import "package:kaiteki/ui/hashtag/screen.dart";
import "package:kaiteki/ui/launcher/dialog.dart";
import "package:kaiteki/ui/lists/lists_screen.dart";
import "package:kaiteki/ui/main/main_screen.dart";
import "package:kaiteki/ui/onboarding/pages/account_setup.dart";
import "package:kaiteki/ui/onboarding/pages/introduction.dart";
import "package:kaiteki/ui/onboarding/pages/preferences_presets.dart";
import "package:kaiteki/ui/onboarding/pages/theme.dart";
import "package:kaiteki/ui/onboarding/screen.dart";
import "package:kaiteki/ui/search/screen.dart";
import "package:kaiteki/ui/settings/a11y/screen.dart";
import "package:kaiteki/ui/settings/about/about_screen.dart";
import "package:kaiteki/ui/settings/customization/post_layout.dart";
import "package:kaiteki/ui/settings/customization/screen.dart";
import "package:kaiteki/ui/settings/debug/theme_screen.dart";
import "package:kaiteki/ui/settings/debug_screen.dart";
import "package:kaiteki/ui/settings/experiments.dart";
import "package:kaiteki/ui/settings/manage_languages.dart";
import "package:kaiteki/ui/settings/settings_screen.dart";
import "package:kaiteki/ui/settings/smart_features_screen.dart";
import "package:kaiteki/ui/settings/tweaks_screen.dart";
import "package:kaiteki/ui/settings/wellbeing/wellbeing_screen.dart";
import "package:kaiteki/ui/shared/account_list/dialog.dart";
import "package:kaiteki/ui/shared/conversation_screen.dart";
import "package:kaiteki/ui/shared/posts/compose/compose_screen.dart";
import "package:kaiteki/ui/shared/posts/user_list_dialog.dart";
import "package:kaiteki/ui/shortcuts/intents.dart";
import "package:kaiteki/ui/user/user_screen.dart";
import "package:kaiteki_core/social.dart";
import "package:kaiteki_core/utils.dart";
import "package:logging/logging.dart";

import "shared_axis_transition_page.dart";

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "root");

final GlobalKey<NavigatorState> _onboardingNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "onboarding");

const authenticatedPath = "/@:accountUsername@:accountHost";

final _logger = Logger("Router");

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider.notifier);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    redirect: notifier.redirect,
    refreshListenable: notifier,
    routes: [
      GoRoute(
        path: "/",
        redirect: (_, __) {
          final account = ref.read(routerNotifierProvider);
          final finishedOnboarding = ref.read(hasFinishedOnboarding).value;

          if (account == null) return "/onboarding";
          if (!finishedOnboarding) return "/onboarding/preferences";

          return "/${account.handle}/home";
        },
      ),
      GoRoute(
        path: "/web-protocol-handler",
        redirect: (context, state) {
          final rawUrl = state.uri.queryParameters["url"];
          if (rawUrl == null) return null;

          final url = Uri.tryParse(rawUrl);
          if (url == null) return null;

          return Uri(path: url.path, query: url.query).toString();
        },
      ),
      ShellRoute(
        navigatorKey: _onboardingNavigatorKey,
        builder: (_, state, child) {
          return OnboardingScreen(child: child);
        },
        routes: [
          GoRoute(
            path: "/onboarding",
            parentNavigatorKey: _onboardingNavigatorKey,
            pageBuilder: (_, __) => const SharedAxisTransitionPage(
              transitionType: SharedAxisTransitionType.horizontal,
              child: IntroductionPage(),
              fillColor: Colors.transparent,
            ),
          ),
          GoRoute(
            path: "/onboarding/account-setup",
            parentNavigatorKey: _onboardingNavigatorKey,
            pageBuilder: (_, __) => const SharedAxisTransitionPage(
              child: AccountSetupPage(),
              transitionType: SharedAxisTransitionType.horizontal,
              fillColor: Colors.transparent,
            ),
          ),
          GoRoute(
            path: "/onboarding/preferences",
            parentNavigatorKey: _onboardingNavigatorKey,
            pageBuilder: (_, __) => const SharedAxisTransitionPage(
              child: PreferencesSetupPage(),
              transitionType: SharedAxisTransitionType.horizontal,
              fillColor: Colors.transparent,
            ),
          ),
          GoRoute(
            path: "/onboarding/theme",
            parentNavigatorKey: _onboardingNavigatorKey,
            pageBuilder: (_, __) => const SharedAxisTransitionPage(
              child: ThemePage(),
              transitionType: SharedAxisTransitionType.horizontal,
              fillColor: Colors.transparent,
            ),
          ),
        ],
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
            name: "tweaks",
            path: "tweaks",
            builder: (_, __) => const TweaksScreen(),
          ),
          GoRoute(
            path: "debug",
            builder: (_, __) => const DebugScreen(),
            routes: [
              GoRoute(
                path: "theme",
                builder: (_, __) => const ThemeScreen(),
              ),
            ],
          ),
          GoRoute(
            path: "accessibility",
            builder: (_, __) => const AccessibilityScreen(),
          ),
          GoRoute(
            path: "smart-features",
            builder: (_, __) => const SmartFeaturesScreen(),
          ),
          GoRoute(
            path: "visible-languages",
            name: "visibleLanguageSettings",
            builder: (_, __) => const ManageLanaguagesScreen(),
          ),
        ],
      ),
      GoRoute(
        name: "login",
        path: "/login",
        builder: (_, __) => const LoginScreen(),
        parentNavigatorKey: _rootNavigatorKey,
      ),
      GoRoute(
        name: "oauth",
        path: "/oauth/:type/:host",
        builder: (_, state) {
          final type = ApiType.values
              .firstWhere((e) => e.name == state.pathParameters["type"]!);
          final host = state.pathParameters["host"]!;

          final extra = popExtra(
            ref.read(sharedPreferencesProvider),
            type,
            host,
          );

          return OAuthFinalizationScreen(
            type: type,
            host: host,
            query: state.uri.queryParameters,
            extra: extra,
          );
        },
        parentNavigatorKey: _rootNavigatorKey,
      ),
      GoRoute(
        name: "authenticated",
        path: authenticatedPath,
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

            final currentAccount = ref.read(accountManagerProvider).current;
            if (account == null) {
              throw StateError("Couldn't find account $user@$host");
            }

            if (currentAccount != account) {
              ref.read(accountManagerProvider.notifier).change(account);

              _logger.info(
                "Switched from ${currentAccount?.key.handle} to ${account.key.handle} due to navigation path",
              );
            }
          }

          if (state.fullPath == authenticatedPath) {
            return "${state.uri}/home";
          }

          return null;
        },
        routes: [
          ShellRoute(
            // navigatorKey: _authNavigatorKey,
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
                builder: (_, state) {
                  final query = state.uri.queryParameters["q"];

                  if (query == null || query.isEmpty) {
                    return const SearchScreen();
                  }

                  return SearchScreen(query: query);
                },
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
                name: "hashtag",
                path: "hashtags/:hashtag",
                pageBuilder: (context, state) {
                  final hashtag = state.pathParameters["hashtag"]!;
                  return _DialogPage(
                    builder: (_) => HashtagScreen(hashtag),
                  );
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
              GoRoute(
                path: "announcements",
                name: "announcements",
                pageBuilder: (context, state) {
                  return _DialogPage(
                    builder: (_) => const AnnouncementsDialog(),
                  );
                },
              ),
              GoRoute(
                path: "follow-requests",
                name: "follow-requests",
                pageBuilder: (context, state) {
                  return _DialogPage(
                    builder: (_) => const FollowRequestsDialog(),
                  );
                },
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
  return FocusableActionDetector(
    actions: {
      OpenLauncherIntent: CallbackAction<OpenLauncherIntent>(
        onInvoke: (_) {
          showDialog(
            context: context,
            builder: (context) => const LauncherDialog(),
          );
          return null;
        },
      ),
    },
    child: Consumer(
      child: child,
      builder: (context, ref, child) {
        final Account? account;

        final user = state.pathParameters["accountUsername"];
        final host = state.pathParameters["accountHost"];

        assert(user != null && host != null);

        account = ref.read(
          accountManagerProvider.select(
            (manager) => manager.accounts.firstWhere(
              (account) =>
                  account.key.username == user! && account.key.host == host!,
            ),
          ),
        );

        _logger.finest("Consumer Rebuild: ${account?.user.handle}");

        if (account != null) {
          return ProviderScope(
            overrides: [
              adapterProvider.overrideWithValue(account.adapter),
              currentAccountProvider.overrideWithValue(account),
            ],
            child: child!,
          );
        }

        _logger.warning("Building route on authenticated path without account");
        return child!;
      },
    ),
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
