import "package:animations/animations.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/services/notifications.dart";
import "package:kaiteki/fediverse/services/timeline.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/theming/text_theme.dart";
import "package:kaiteki/ui/main/pages/bookmarks.dart";
import "package:kaiteki/ui/main/pages/chats.dart";
import "package:kaiteki/ui/main/pages/explore.dart";
import "package:kaiteki/ui/main/pages/home.dart";
import "package:kaiteki/ui/main/pages/notifications.dart";
import "package:kaiteki/ui/main/pages/placeholder.dart";
import "package:kaiteki/ui/pride.dart";
import "package:kaiteki/ui/shared/account_switcher_widget.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/dialogs/keyboard_shortcuts_dialog.dart";
import "package:kaiteki/ui/shortcuts/intents.dart";
import "package:kaiteki/ui/window_class.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:logging/logging.dart";

import "drawer.dart";
import "fab_data.dart";
import "navigation/navigation_bar.dart";
import "navigation/navigation_rail.dart";
import "tab.dart";
import "tab_kind.dart";

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
  TabKind _currentTab = TabKind.home;

  late List<TabKind> _tabs;

  VoidCallback? get _search {
    if (ref.watch(adapterProvider) is! SearchSupport) return null;
    return () {
      context.pushNamed("search", pathParameters: ref.accountRouterParams);
    };
  }

  @override
  Widget build(BuildContext context) {
    if (ref.read(AppExperiment.navigationBarTheming.provider)) {
      setSystemUIOverlayStyle(context);
    }

    _tabs = getTabs();

    final windowClass = WindowClass.fromContext(context);
    final isCompact = windowClass <= WindowClass.compact;

    final tabItems = _tabs.map((e) => buildTabItem(context, e)).toList();
    final tabItem = tabItems.firstWhereOrNull((e) => e.kind == _currentTab);

    Widget? buildFloatingActionButton() {
      final fabData = tabItem?.fab;
      if (fabData == null) return null;

      final hideFabWhenDesktop = tabItem?.hideFabWhenDesktop ?? false;
      if (!isCompact && hideFabWhenDesktop) return null;

      if (windowClass >= WindowClass.expanded) {
        return FloatingActionButton.extended(
          label: Text(fabData.text),
          icon: Icon(fabData.icon),
          onPressed: fabData.onTap,
        );
      }

      return FloatingActionButton(
        tooltip: fabData.tooltip,
        onPressed: fabData.onTap,
        child: Icon(fabData.icon),
      );
    }

    int getCurrentIndex() {
      final index = _tabs.indexOf(_currentTab);
      if (index == -1) return 0;
      return index;
    }

    final prideEnabled = ref.watch(enablePrideFlag).value;
    final prideFlagDesign = ref.watch(prideFlag).value;

    final scaffold = Scaffold(
      backgroundColor: prideEnabled || !isCompact ? Colors.transparent : null,
      appBar: buildAppBar(context, !isCompact),
      body: _BodyWrapper(
        tabs: tabItems,
        currentIndex: getCurrentIndex(),
        onChangeIndex: (i) => _changeTab(_tabs[i]),
        child: buildPage(context, _currentTab),
      ),
      bottomNavigationBar: isCompact && tabItems.length >= 2
          ? MainScreenNavigationBar(
              tabs: tabItems,
              currentIndex: getCurrentIndex(),
              onChangeIndex: (i) => _changeTab(_tabs[i]),
            )
          : null,
      floatingActionButton: buildFloatingActionButton(),
      drawer: const MainScreenDrawer(),
    );

    return FocusableActionDetector(
      autofocus: true,
      actions: getActions(context),
      child: ColoredBox(
        color:
            getOutsideColor(context) ?? Theme.of(context).colorScheme.surface,
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
      forceMaterialTransparency: immerse && theme.useMaterial3,
      title: Text(kAppName, style: kaitekiTextStyle),
      actions: _buildAppBarActions(context),
      scrolledUnderElevation: immerse ? 0.0 : null,
    );
  }

  Widget buildPage(BuildContext context, TabKind tab) {
    final isCompact = WindowClass.fromContext(context) <= WindowClass.compact;
    return switch (tab) {
      TabKind.home => HomePage(
          key: _homePageKey,
          initialTimeline: widget.initialTimeline,
          tabAlignment: isCompact ? null : TabAlignment.center,
        ),
      TabKind.notifications => const NotificationsPage(),
      TabKind.chats => const ChatsPage(),
      TabKind.bookmarks => const BookmarksPage(),
      TabKind.explore => const ExplorePage(),
      TabKind.directMessages => const PlaceholderPage(),
    };
  }

  MainScreenTab buildTabItem(BuildContext context, TabKind kind) {
    final l10n = context.l10n;

    return switch (kind) {
      TabKind.home => MainScreenTab(
          TabKind.home,
          fab: FloatingActionButtonData(
            icon: Icons.edit_rounded,
            tooltip: l10n.composeDialogTitle,
            text: l10n.composeButtonLabel,
            onTap: () => context.pushNamed(
              "compose",
              pathParameters: ref.accountRouterParams,
            ),
          ),
          hideFabWhenDesktop: true,
        ),
      TabKind.notifications => MainScreenTab(
          TabKind.notifications,
          fetchUnreadCount: () =>
              ref.watch(notificationCountProvider).valueOrNull,
        ),
      _ => MainScreenTab(kind),
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

  Color? getOutsideColor(BuildContext context) {
    final theme = Theme.of(context);
    if (theme.useMaterial3) return theme.colorScheme.surfaceContainer;
    return null;
  }

  List<TabKind> getTabs() {
    final adapter = ref.watch(adapterProvider);

    final supportsNotifications = adapter is NotificationSupport;
    final supportsChats =
        adapter.safeCast<ChatSupport>()?.capabilities.supportsChat ?? false;
    final supportsBookmarks = adapter is BookmarkSupport;
    final supportsExplore = adapter is ExploreSupport;

    final chatsEnabled = ref.watch(AppExperiment.chats.provider);

    return [
      TabKind.home,
      if (supportsNotifications) TabKind.notifications,
      if (supportsChats && chatsEnabled) TabKind.chats,
      if (supportsBookmarks) TabKind.bookmarks,
      if (supportsExplore) TabKind.explore,
    ];
  }

  Future<void> onRefresh() async {
    final accountKey = ref.read(currentAccountProvider)!.key;

    switch (_currentTab) {
      case TabKind.notifications:
        ref.invalidate(notificationServiceProvider(accountKey));
        break;

      case TabKind.home:
        final timeline = _homePageKey.currentState?.timeline;

        if (timeline == null) {
          Logger("MainScreen").warning(
            "I wanted to refresh the timeline, but I didn't get the timeline source back from the home page.",
          );
          return;
        }

        ref.invalidate(timelineServiceProvider(accountKey, timeline));
        break;

      case TabKind.chats:
      case TabKind.bookmarks:
      case TabKind.explore:
      case TabKind.directMessages:
        break;
    }
  }

  void setSystemUIOverlayStyle(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: ElevationOverlay.applySurfaceTint(
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surfaceTint,
          3,
        ),
        systemNavigationBarDividerColor:
            Theme.of(context).colorScheme.surfaceVariant,
        systemNavigationBarIconBrightness:
            Theme.of(context).colorScheme.brightness.inverted,
      ),
    );
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
        _changeTab(TabKind.home);
        break;
      case AppLocation.notifications:
        _changeTab(TabKind.notifications);
        break;
      case AppLocation.bookmarks:
        _changeTab(TabKind.bookmarks);
        break;
      case AppLocation.settings:
        context.push("/settings");
        break;
      default:
        break;
    }
  }

  void _changeTab(TabKind tab) => setState(() => _currentTab = tab);
}

class _BodyWrapper extends StatelessWidget {
  final Widget child;
  final List<MainScreenTab>? tabs;
  final int currentIndex;
  final ValueChanged<int>? onChangeIndex;

  const _BodyWrapper({
    required this.child,
    this.tabs,
    required this.currentIndex,
    required this.onChangeIndex,
  });

  @override
  Widget build(BuildContext context) {
    var body = child;

    final useMaterial3 = Theme.of(context).useMaterial3;

    if (useMaterial3) {
      body = Material(
        color: Theme.of(context).colorScheme.surface,
        child: body,
      );
    }

    body = PageTransitionSwitcher(
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
        return FadeThroughTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      child: child,
    );

    final isCompact = WindowClass.fromContext(context) <= WindowClass.compact;
    if (isCompact) return body;

    if (useMaterial3) {
      body = ClipRRect(
        borderRadius: const BorderRadiusDirectional.only(
          topStart: Radius.circular(16.0),
        ),
        child: body,
      );
    }

    final tabs = this.tabs;
    final canShowRail = !(tabs == null || tabs.length < 2);

    if (canShowRail) {
      body = Row(
        children: [
          MainScreenNavigationRail(
            tabs: tabs,
            currentIndex: currentIndex,
            onChangeIndex: onChangeIndex,
            backgroundColor: Colors.transparent,
          ),
          if (!useMaterial3) const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: body),
        ],
      );
    }

    return body;
  }
}
