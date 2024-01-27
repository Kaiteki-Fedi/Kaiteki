import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/services/bookmarks.dart";
import "package:kaiteki/fediverse/services/notifications.dart";
import "package:kaiteki/fediverse/services/timeline.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:kaiteki/preferences/app_preferences.dart" as preferences;
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/theming/text_theme.dart";
import "package:kaiteki/ui/main/pages/bookmarks.dart";
import "package:kaiteki/ui/main/pages/chats.dart";
import "package:kaiteki/ui/main/pages/explore.dart";
import "package:kaiteki/ui/main/pages/home.dart";
import "package:kaiteki/ui/main/pages/notifications.dart";
import "package:kaiteki/ui/pride.dart";
import "package:kaiteki/ui/shared/account_switcher_widget.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/dialogs/keyboard_shortcuts_dialog.dart";
import "package:kaiteki/ui/shortcuts/intents.dart";
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
    final prideFlagDesign = ref.watch(prideFlag).value;

    final scaffold = Scaffold(
      backgroundColor: prideEnabled || !isCompact ? Colors.transparent : null,
      appBar: buildAppBar(context, !isCompact),
      body: _BodyWrapper(
        tabTypes: _tabs,
        currentIndex: currentIndex,
        onChangeIndex: (i) => _changeTab(_tabs[i]),
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

    return Actions(
      actions: getActions(context),
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: prideEnabled && !isCompact
            ? Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: PridePainter(prideFlagDesign, opacity: .35),
                    ),
                  ),
                  scaffold,
                ],
              )
            : scaffold,
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context, bool immerse) {
    final theme = Theme.of(context);

    Color? foregroundColor;

    if (immerse) {
      foregroundColor = theme.colorScheme.onSurface;
    }

    final kaitekiTextStyle = theme.ktkTextTheme?.kaitekiTextStyle ??
        DefaultKaitekiTextTheme(context).kaitekiTextStyle;
    return AppBar(
      foregroundColor: foregroundColor,
      forceMaterialTransparency: immerse,
      title: Text(kAppName, style: kaitekiTextStyle),
      actions: _buildAppBarActions(context),
      scrolledUnderElevation: immerse ? 0.0 : null,
    );
  }

  Widget buildPage(BuildContext context, MainScreenTabType tab) {
    final isCompact = WindowWidthSizeClass.fromContext(context) <=
        WindowWidthSizeClass.compact;
    return switch (tab) {
      MainScreenTabType.home => HomePage(
          key: _homePageKey,
          initialTimeline: widget.initialTimeline,
          tabAlignment: isCompact ? null : TabAlignment.center,
        ),
      MainScreenTabType.notifications => const NotificationsPage(),
      MainScreenTabType.chats => const ChatsPage(),
      MainScreenTabType.bookmarks => const BookmarksPage(),
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

      case MainScreenTabType.bookmarks:
        ref.invalidate(bookmarksServiceProvider(accountKey));
        break;

      case MainScreenTabType.chats:
      case MainScreenTabType.explore:
        break;
    }
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    final l10n = context.l10n;

    return [
      IconButton(
        icon: const Icon(Icons.search_rounded),
        onPressed: _search,
        tooltip: l10n.searchButtonLabel,
      ),
      if (ref.watch(pointingDeviceProvider) == PointingDevice.mouse)
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: onRefresh,
          tooltip: l10n.refreshTimelineButtonLabel,
        ),
      const AccountSwitcherWidget(size: 40),
    ];
  }

  void _changeLocation(GoToAppLocationIntent i) {
    switch (i.location) {
      case AppLocation.home:
        _changeTab(MainScreenTabType.home);
        break;
      case AppLocation.notifications:
        _changeTab(MainScreenTabType.notifications);
        break;
      case AppLocation.bookmarks:
        _changeTab(MainScreenTabType.bookmarks);
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
        systemNavigationBarDividerColor: theme.colorScheme.surfaceVariant,
        systemNavigationBarIconBrightness:
            theme.colorScheme.brightness.inverted,
      ),
    );
  }
}

class _BodyWrapper extends StatelessWidget {
  final Widget child;
  final List<MainScreenTabType>? tabTypes;
  final int currentIndex;
  final ValueChanged<int>? onChangeIndex;

  const _BodyWrapper({
    required this.child,
    this.tabTypes,
    required this.currentIndex,
    required this.onChangeIndex,
  });

  @override
  Widget build(BuildContext context) {
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
          color: Theme.of(context).colorScheme.surface,
          child: child,
        ),
      ),
    );

    final isCompact = WindowWidthSizeClass.fromContext(context) <=
        WindowWidthSizeClass.compact;
    if (isCompact) return body;

    body = ClipRRect(
      borderRadius: const BorderRadiusDirectional.only(
        topStart: Radius.circular(16.0),
      ),
      child: body,
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
