import "dart:async";

import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/services/notifications.dart";
import "package:kaiteki/fediverse/services/timeline.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:kaiteki/preferences/app_preferences.dart" as preferences;
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/ui/main/pages/chats.dart";
import "package:kaiteki/ui/main/pages/explore.dart";
import "package:kaiteki/ui/main/pages/home.dart";
import "package:kaiteki/ui/main/pages/notifications.dart";
import "package:kaiteki/ui/pride.dart";
import "package:kaiteki/ui/search/suggestion_list_tiles/header.dart";
import "package:kaiteki/ui/search/suggestion_list_tiles/post.dart";
import "package:kaiteki/ui/search/suggestion_list_tiles/user.dart";
import "package:kaiteki/ui/shared/account_switcher.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/dialogs/keyboard_shortcuts_dialog.dart";
import "package:kaiteki/ui/shortcuts/intents.dart";
import "package:kaiteki/utils/debounce.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:logging/logging.dart";

import "drawer.dart";
import "navigation/navigation_bar.dart";
import "navigation/navigation_rail.dart";
import "tabs/tab.dart";

final notificationCountProvider = FutureProvider<int?>(
  (ref) {
    final account = ref.watch(currentAccountProvider);

    if (account == null) return null;
    if (account.adapter is! NotificationSupport) return null;

    final notifications = ref.watch(notificationServiceProvider(account.key));
    return notifications.valueOrNull?.items
        .where((n) => n.unread != false)
        .length;
  },
  dependencies: [currentAccountProvider, notificationServiceProvider],
);

Future<void> showKeyboardShortcuts(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (_) => const KeyboardShortcutsDialog(),
  );
}

class MainScreen extends ConsumerStatefulWidget {
  @visibleForTesting
  final TimelineType? initialTimeline;

  const MainScreen({super.key, this.initialTimeline});

  @override
  ConsumerState<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends ConsumerState<MainScreen> {
  final _homePageKey = GlobalKey<HomePageState>();
  MainScreenTabType _currentTab = MainScreenTabType.home;

  late List<MainScreenTabType> _tabs;
  late final SearchController _searchController;
  late final Debounceable<SearchResults, String> _searchDebounce;

  @override
  void initState() {
    super.initState();

    _searchController = SearchController();

    _searchDebounce = debounce(
      (query) async {
        final adapter = ref.read(adapterProvider);
        if (adapter is SearchSupport) {
          return (adapter as SearchSupport).search(query);
        } else {
          throw UnsupportedError("$adapter does not support search");
        }
      },
      const Duration(milliseconds: 300),
    );
  }

  VoidCallback? get _search {
    if (ref.watch(adapterProvider) is! SearchSupport) return null;
    return () {
      context.pushNamed("search", pathParameters: ref.accountRouterParams);
    };
  }

  @override
  Widget build(BuildContext context) {
    if (ref.read(AppExperiment.navigationBarTheming.provider)) {
      _setSystemUIOverlayStyle(context);
    }

    _tabs = getTabs();

    final currentTab = _tabs.contains(_currentTab) ? _currentTab : _tabs.first;
    final currentIndex = _tabs.indexOf(currentTab);

    final isCompact = WindowWidthSizeClass.fromContext(context) <=
        WindowWidthSizeClass.compact;

    final prideEnabled = ref.watch(enablePrideFlag).value;
    final showPride = prideEnabled && !isCompact;
    final prideFlagDesign = ref.watch(prideFlag).value;

    final appBar = isCompact
        ? _AppBarCompact(
            onSearch: _search,
            onRefresh: onRefresh,
            transparent: !isCompact,
            controller: _searchController,
            suggestionsBuilder: _suggestionsBuilder,
          ) as PreferredSizeWidget
        : _AppBar(
            onSearch: _search,
            onRefresh: onRefresh,
            controller: _searchController,
            suggestionsBuilder: _suggestionsBuilder,
          ) as PreferredSizeWidget;

    final theme = Theme.of(context);
    final containerColor = theme.colorScheme.surfaceContainer;

    final scaffold = Scaffold(
      backgroundColor: isCompact
          ? null
          : showPride
              ? Colors.transparent
              : containerColor,
      appBar: appBar,
      body: _BodyWrapper(
        tabTypes: _tabs,
        currentIndex: currentIndex,
        onChangeIndex: (i) => _changeTab(_tabs[i]),
        searchController: _searchController,
        suggestionsBuilder: _suggestionsBuilder,
        child: buildPage(context, currentTab),
      ),
      bottomNavigationBar: isCompact && _tabs.length >= 2
          ? MainScreenNavigationBar(
              tabTypes: _tabs,
              currentIndex: currentIndex,
              onChangeIndex: (i) => _changeTab(_tabs[i]),
            )
          : null,
      floatingActionButton: currentTab.tab?.buildFab(context, ref),
      floatingActionButtonLocation:
          currentTab.tab?.fabLocation ?? FloatingActionButtonLocation.endFloat,
      drawer: const MainScreenDrawer(),
    );

    Widget widget = scaffold;

    if (showPride) {
      widget = ColoredBox(
        color: containerColor,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: PridePainter(prideFlagDesign, opacity: .35),
              ),
            ),
            scaffold,
          ],
        ),
      );
    }

    return Actions(
      actions: getActions(context),
      child: widget,
    );
  }

  Widget buildPage(BuildContext context, MainScreenTabType tab) {
    return switch (tab) {
      MainScreenTabType.home => HomePage(
          key: _homePageKey,
          initialTimeline: widget.initialTimeline,
          tabAlignment: TabAlignment.center,
        ),
      MainScreenTabType.notifications => const NotificationsPage(),
      MainScreenTabType.chats => const ChatsPage(),
      MainScreenTabType.explore => const ExplorePage(),
    };
  }

  Map<Type, Action<Intent>> getActions(BuildContext context) {
    return {
      NewPostIntent: CallbackAction(
        onInvoke: (_) => context.pushNamed(
          "compose",
          pathParameters: ref.accountRouterParams,
        ),
      ),
      SearchIntent: CallbackAction(
        onInvoke: (_) => _search?.call(),
      ),
      RefreshIntent: CallbackAction(onInvoke: (_) => onRefresh()),
      GoToAppLocationIntent: CallbackAction<GoToAppLocationIntent>(
        onInvoke: _changeLocation,
      ),
      ShortcutsHelpIntent: CallbackAction(
        onInvoke: (_) => showKeyboardShortcuts(context),
      ),
    };
  }

  List<MainScreenTabType> getTabs() {
    final adapter = ref.watch(adapterProvider);
    final chatsEnabled = ref.watch(AppExperiment.chats.provider);
    final tabOrder = ref.watch(preferences.mainScreenTabOrder).value;
    final disabledTabs = ref.watch(preferences.disabledMainScreenTabs).value;

    return tabOrder
        .where((e) => e.tab?.isAvailable(adapter) ?? true)
        .where((e) => !(e == MainScreenTabType.chats && !chatsEnabled))
        .where((e) => !disabledTabs.contains(e))
        .toList();
  }

  Future<void> onRefresh() async {
    final accountKey = ref.read(currentAccountProvider)!.key;

    switch (_currentTab) {
      case MainScreenTabType.notifications:
        ref.invalidate(notificationServiceProvider(accountKey));
        break;

      case MainScreenTabType.home:
        final timeline = _homePageKey.currentState?.timeline;

        if (timeline == null) {
          Logger("MainScreen").warning(
            "I wanted to refresh the timeline, but I didn't get the timeline source back from the home page.",
          );
          return;
        }

        ref.invalidate(timelineServiceProvider(accountKey, timeline));
        break;

      case MainScreenTabType.chats:
      case MainScreenTabType.explore:
        break;
    }
  }

  void _changeLocation(GoToAppLocationIntent i) {
    switch (i.location) {
      case AppLocation.home:
        _changeTab(MainScreenTabType.home);
        break;
      case AppLocation.notifications:
        _changeTab(MainScreenTabType.notifications);
        break;
      case AppLocation.settings:
        context.push("/settings");
        break;
      default:
        break;
    }
  }

  void _changeTab(MainScreenTabType tab) {
    if (_currentTab == tab) {
      if (tab == MainScreenTabType.home) {
        _homePageKey.currentState?.scrollToTop();
      }

      return;
    }

    setState(() => _currentTab = tab);
  }

  void _setSystemUIOverlayStyle(BuildContext context) {
    final theme = Theme.of(context);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: ElevationOverlay.applySurfaceTint(
          theme.colorScheme.surface,
          theme.colorScheme.surfaceTint,
          3,
        ),
        systemNavigationBarDividerColor:
            theme.colorScheme.surfaceContainerHighest,
        systemNavigationBarIconBrightness:
            theme.colorScheme.brightness.inverted,
      ),
    );
  }

  FutureOr<Iterable<Widget>> _suggestionsBuilder(
    BuildContext context,
    SearchController controller,
  ) async {
    final l10n = context.l10n;

    final query = controller.text.trim();
    if (query.isEmpty) return [];

    final results = await _searchDebounce(query);
    if (results == null) return [];

    if (results.users.isEmpty &&
        results.posts.isEmpty &&
        results.hashtags.isEmpty) {
      return [
        ListTile(
          title: Text(l10n.empty),
          leading: const Icon(Icons.search_off_rounded),
        ),
      ];
    }

    return [
      if (results.posts.isNotEmpty) ...[
        HeaderSuggestionListTile(Text(l10n.postsTab)),
        ...results.posts.take(3).map((e) {
          return PostSuggestionListTile(
            e,
            onTap: () => context.pushNamed(
              "post",
              pathParameters: {...ref.accountRouterParams, "id": e.id},
            ),
          );
        }),
      ],
      if (results.users.isNotEmpty) ...[
        HeaderSuggestionListTile(Text(l10n.usersTab)),
        ...results.users.take(3).map((e) {
          return UserSuggestionListTile(
            e,
            onTap: () => context.pushNamed(
              "user",
              pathParameters: {...ref.accountRouterParams, "id": e.id},
            ),
          );
        }),
      ],
      if (results.hashtags.isNotEmpty) ...[
        const HeaderSuggestionListTile(Text("Hashtags")),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              for (final hashtag in results.hashtags.take(3))
                ActionChip(
                  // ignore: l10n
                  label: Text("#$hashtag"),
                  onPressed: () => context.pushNamed(
                    "hashtag",
                    pathParameters: {
                      ...ref.accountRouterParams,
                      "hashtag": hashtag,
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    ];
  }
}

class _BodyWrapper extends ConsumerWidget {
  final Widget child;
  final List<MainScreenTabType>? tabTypes;
  final int currentIndex;
  final ValueChanged<int>? onChangeIndex;
  final SearchController? searchController;
  final SuggestionsBuilder suggestionsBuilder;

  const _BodyWrapper({
    required this.child,
    this.tabTypes,
    required this.currentIndex,
    required this.onChangeIndex,
    this.searchController,
    required this.suggestionsBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    Widget body = Focus(
      autofocus: true,
      child: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: Material(
          color: theme.colorScheme.surface,
          child: child,
        ),
      ),
    );

    final isCompact = WindowWidthSizeClass.fromContext(context) <=
        WindowWidthSizeClass.compact;
    if (isCompact) return body;

    var shape = const RoundedRectangleBorder(
      borderRadius: BorderRadiusDirectional.vertical(
        top: Radius.circular(16.0),
      ),
    );

    if (ref.watch(useHighContrast).value) {
      shape = shape.copyWith(
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
        ),
      );
    }

    body = Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: Material(
        clipBehavior: Clip.antiAlias,
        shape: shape,
        child: body,
      ),
    );

    final tabTypes = this.tabTypes;
    final canShowRail = !(tabTypes == null || tabTypes.length < 2);

    if (canShowRail) {
      body = Row(
        children: [
          FocusTraversalGroup(
            child: MainScreenNavigationRail(
              tabTypes: tabTypes,
              currentIndex: currentIndex,
              onChangeIndex: onChangeIndex,
              backgroundColor: Colors.transparent,
            ),
          ),
          Expanded(child: body),
        ],
      );
    }

    return body;
  }
}

class _SearchBar extends ConsumerWidget {
  final SearchController? controller;
  final SuggestionsBuilder suggestionsBuilder;

  const _SearchBar({
    this.controller,
    required this.suggestionsBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final host = ref.watch(currentAccountProvider)!.key.host;
    return SearchAnchor(
      searchController: controller,
      builder: (context, controller) => SearchBar(
        controller: controller,
        padding: const MaterialStatePropertyAll(
          EdgeInsets.only(left: 16.0, right: 8.0),
        ),
        trailing: const [AccountSwitcher(size: 30)],
        leading: const Icon(Icons.search_rounded),
        elevation: const MaterialStatePropertyAll(0),
        hintText: "Search $host",
        onChanged: (_) => controller.openView(),
        onSubmitted: (query) {
          controller.closeView(null);
          context.pushNamed(
            "search",
            pathParameters: {...ref.accountRouterParams},
            queryParameters: {"q": query},
          );
        },
      ),
      suggestionsBuilder: suggestionsBuilder,
    );
  }
}

class _AppBar extends ConsumerWidget implements PreferredSizeWidget {
  final VoidCallback? onSearch;
  final VoidCallback onRefresh;
  final SearchController? controller;
  final SuggestionsBuilder suggestionsBuilder;

  const _AppBar({
    this.onSearch,
    required this.onRefresh,
    this.controller,
    required this.suggestionsBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final materialL10n = context.materialL10n;

    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: materialL10n.openAppDrawerTooltip,
            padding: const EdgeInsets.all(16.0),
          ),
        ),
      ),
      leadingWidth: 56.0 + 16.0,
      foregroundColor: theme.colorScheme.onSurface,
      forceMaterialTransparency: true,
      title: Padding(
        padding: const EdgeInsets.only(left: 24.0),
        child: _SearchBar(
          controller: controller,
          suggestionsBuilder: suggestionsBuilder,
        ),
      ),
      toolbarHeight: 56.0 + 8.0 * 2,
      centerTitle: true,
      actions: [
        if (ref.watch(showRefreshButton).value)
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: onRefresh,
            tooltip: l10n.refreshTimelineButtonLabel,
          ),
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              // if (_currentTab == MainScreenTabType.home)
              PopupMenuItem(
                enabled: false,
                onTap: () => context.pushNamed("tabs-settings"),
                child: const Text("Edit timelines"),
              ),
            ];
          },
        ),
        const SizedBox(width: 16.0),
      ],
      scrolledUnderElevation: 0.0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0 + 8.0 * 2);
}

class _AppBarCompact extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onSearch;
  final VoidCallback onRefresh;
  final bool transparent;
  final SearchController? controller;
  final SuggestionsBuilder suggestionsBuilder;

  const _AppBarCompact({
    this.onSearch,
    required this.onRefresh,
    this.transparent = false,
    this.controller,
    required this.suggestionsBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: _CompactSearchBar(
          controller: controller,
          suggestionsBuilder: suggestionsBuilder,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0 + 8.0 * 2);
}

class _CompactSearchBar extends ConsumerWidget {
  const _CompactSearchBar({
    required this.controller,
    required this.suggestionsBuilder,
  });

  final SearchController? controller;
  final SuggestionsBuilder suggestionsBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final host = ref.watch(currentAccountProvider.select((e) => e?.key.host))!;
    return SearchAnchor(
      isFullScreen: true,
      searchController: controller,
      builder: (context, controller) => SearchBar(
        controller: controller,
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 8.0),
        ),
        trailing: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  enabled: false,
                  onTap: () => context.pushNamed("tabs-settings"),
                  child: const Text("Edit timelines"),
                ),
              ];
            },
          ),
          const AccountSwitcher(size: 30),
        ],
        leading: const DrawerButton(),
        hintText: "Search $host",
        onChanged: (_) => controller.openView(),
        onSubmitted: (query) {
          controller.closeView(null);
          context.pushNamed(
            "search",
            pathParameters: {...ref.accountRouterParams},
            queryParameters: {"q": query},
          );
        },
        shadowColor: const MaterialStatePropertyAll(Colors.transparent),
      ),
      suggestionsBuilder: suggestionsBuilder,
    );
  }
}
