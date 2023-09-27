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
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";
import "package:kaiteki/ui/main/pages/bookmarks.dart";
import "package:kaiteki/ui/main/pages/chats.dart";
import "package:kaiteki/ui/main/pages/explore.dart";
import "package:kaiteki/ui/main/pages/notifications.dart";
import "package:kaiteki/ui/main/pages/placeholder.dart";
import "package:kaiteki/ui/main/pages/timeline.dart";
import "package:kaiteki/ui/preferred_size_stack.dart";
import "package:kaiteki/ui/pride.dart";
import "package:kaiteki/ui/shared/account_switcher_widget.dart";
import "package:kaiteki/ui/shared/dialogs/keyboard_shortcuts_dialog.dart";
import "package:kaiteki/ui/shared/side_sheet_manager.dart";
import "package:kaiteki/ui/shared/timeline/source.dart";
import "package:kaiteki/ui/shortcuts/intents.dart";
import "package:kaiteki/ui/window_class.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/kaiteki_core.dart";

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
    return notifications.valueOrNull?.where((n) => n.unread != false).length;
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
  // Why does this exist? In order to refresh the timeline
  final _timelineKey = GlobalKey<TimelinePageState>();
  TabKind _currentTab = TabKind.home;

  late List<TabKind> _tabs;

  VoidCallback? get _refresh {
    switch (_currentTab) {
      case TabKind.home:
        final timeline = _timelineKey.currentState?.timeline;
        if (timeline == null) return null;
        final account = ref.watch(currentAccountProvider)!.key;
        return ref
            .read(
              timelineServiceProvider(
                account,
                StandardTimelineSource(timeline),
              ).notifier,
            )
            .refresh;

      case TabKind.notifications:
        final account = ref.watch(currentAccountProvider)!.key;
        return ref.read(notificationServiceProvider(account).notifier).refresh;

      default:
        return null;
    }
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

    return FocusableActionDetector(
      autofocus: true,
      actions: {
        NewPostIntent: CallbackAction(
          onInvoke: (_) => context.pushNamed(
            "compose",
            pathParameters: ref.accountRouterParams,
          ),
        ),
        SearchIntent: CallbackAction(
          onInvoke: (_) => _search?.call(),
        ),
        RefreshIntent: CallbackAction(onInvoke: (_) => _refresh?.call()),
        GoToAppLocationIntent: CallbackAction<GoToAppLocationIntent>(
          onInvoke: _changeLocation,
        ),
        ShortcutsHelpIntent: CallbackAction(
          onInvoke: (_) => showKeyboardShortcuts(context),
        ),
      },
      child: buildView(context),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context, bool immerse) {
    if (ref.watch(useSearchBar).value) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(56.0 + 8.0 * 2),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              focusNode: FocusNode(canRequestFocus: false, skipTraversal: true),
              onTap: () => context.pushNamed(
                "search",
                pathParameters: ref.accountRouterParams,
              ),
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              leading: const DrawerButton(),
              hintText: "Search",
              trailing: const [
                AccountSwitcherWidget(size: 30),
              ],
            ),
          ),
        ),
      );
    }

    Color? backgroundColor, foregroundColor;

    if (immerse) {
      backgroundColor = getOutsideColor(context);
      if (backgroundColor != null) {
        foregroundColor = ThemeData.estimateBrightnessForColor(backgroundColor)
            .inverted
            .getColor();
      }
    }

    final theme = Theme.of(context);
    const shadows = [
      Shadow(color: Colors.white, blurRadius: 1),
      Shadow(color: Colors.white, blurRadius: 2),
      Shadow(color: Colors.white, blurRadius: 4),
    ];
    final prideEnabled = ref.watch(enablePrideFlag).value;
    final prideFlagDesign = ref.watch(prideFlag).value;
    return PreferredSizeStack(
      bottom: prideEnabled
          ? CustomPaint(painter: PridePainter(prideFlagDesign))
          : null,
      primary: AppBar(
        foregroundColor: prideEnabled ? Colors.black : foregroundColor,
        forceMaterialTransparency: theme.useMaterial3,
        title: Text(
          kAppName,
          style: (theme.ktkTextTheme?.kaitekiTextStyle ??
                  DefaultKaitekiTextTheme(context).kaitekiTextStyle)
              .copyWith(
            shadows: prideEnabled ? shadows : null,
          ),
        ),
        iconTheme: prideEnabled ? const IconThemeData(shadows: shadows) : null,
        actions: _buildAppBarActions(context),
        scrolledUnderElevation: immerse ? 0.0 : null,
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    final body = buildPage(context, _currentTab);
    return PageTransitionSwitcher(
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
        return FadeThroughTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      child: Material(
        color: Theme.of(context).useMaterial3
            ? Theme.of(context).colorScheme.surface
            : null,
        child: body,
      ),
    );
  }

  Widget? buildFloatingActionButton(
    BuildContext context,
    FloatingActionButtonData data,
    bool extended,
  ) {
    if (extended) {
      return FloatingActionButton.extended(
        label: Text(data.text),
        icon: Icon(data.icon),
        onPressed: data.onTap,
      );
    }

    return FloatingActionButton(
      tooltip: data.tooltip,
      onPressed: data.onTap,
      child: Icon(data.icon),
    );
  }

  Widget buildPage(BuildContext context, TabKind tab) {
    return switch (tab) {
      TabKind.home => TimelinePage(
          initialTimeline: widget.initialTimeline,
          tabAlignment: WindowClass.fromContext(context) <= WindowClass.compact
              ? null
              : TabAlignment.center,
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

  Widget buildView(BuildContext context) {
    _tabs = getTabs();

    final body = buildBody(context);

    final windowClass = WindowClass.fromContext(context);
    final isCompact = windowClass <= WindowClass.compact;

    final tabItems = _tabs.map((e) => buildTabItem(context, e)).toList();
    final tabItem = tabItems.firstWhereOrNull((e) => e.kind == _currentTab);

    return SideSheetManager(
      builder: (sideSheet) => Scaffold(
        backgroundColor: isCompact ? null : getOutsideColor(context),
        appBar: buildAppBar(context, !isCompact),
        endDrawer: sideSheet,
        endDrawerEnableOpenDragGesture: false,
        body: isCompact
            ? body
            : _buildDesktopView(
                context,
                windowClass,
                body,
                tabItems,
              ),
        bottomNavigationBar: isCompact && tabItems.length >= 2
            ? MainScreenNavigationBar(
                tabs: tabItems,
                currentIndex: _tabs.indexOf(_currentTab),
                onChangeIndex: (i) => _changeTab(_tabs[i]),
              )
            : null,
        floatingActionButton:
            (!isCompact && (tabItem?.hideFabWhenDesktop ?? false))
                ? null
                : tabItem?.fab.nullTransform<Widget?>(
                    (data) => buildFloatingActionButton(
                      context,
                      data,
                      windowClass >= WindowClass.expanded,
                    ),
                  ),
        drawer: const MainScreenDrawer(),
      ),
    );
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
        final notifier =
            ref.read(notificationServiceProvider(accountKey).notifier);
        await notifier.refresh();
        break;

      case TabKind.home:
        final timeline = ref.read(currentTimelineProvider);
        final notifier = ref.read(
          timelineServiceProvider(
            accountKey,
            StandardTimelineSource(timeline),
          ).notifier,
        );
        await notifier.refresh();
        break;

      case TabKind.chats:
      case TabKind.bookmarks:
      case TabKind.explore:
      case TabKind.directMessages:
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
      if (ref.watch(experimentsProvider(AppExperiment.notificationMenu)))
        MenuAnchor(
          menuChildren: const [
            SizedBox(
              width: 400,
              height: 600,
              child: NotificationsPage(),
            ),
          ],
          builder: (context, controller, child) {
            return IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: controller.open,
              tooltip: "Notifications",
            );
          },
        ),
      if (WidgetsBinding.instance.mouseTracker.mouseIsConnected)
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: onRefresh,
          tooltip: l10n.refreshTimelineButtonLabel,
        ),
      const AccountSwitcherWidget(size: 40),
    ];
  }

  Widget _buildDesktopView(
    BuildContext context,
    WindowClass windowClass,
    Widget child,
    List<MainScreenTab> tabItems,
  ) {
    final m3 = Theme.of(context).useMaterial3;
    return Row(
      children: [
        if (_tabs.length >= 2) ...[
          MainScreenNavigationRail(
            tabs: tabItems,
            currentIndex: _tabs.indexOf(_currentTab),
            onChangeIndex: (i) => _changeTab(_tabs[i]),
            backgroundColor: getOutsideColor(context) ?? Colors.transparent,
          ),
          if (!m3) const VerticalDivider(thickness: 1, width: 1),
        ],
        Expanded(
          child: Theme.of(context).useMaterial3
              ? ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                  ),
                  child: child,
                )
              : child,
        ),
      ],
    );
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
