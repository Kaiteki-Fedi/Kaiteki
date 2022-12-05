import 'package:animations/animations.dart';
import 'package:badges/badges.dart';
import 'package:breakpoint/breakpoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/interfaces/notification_support.dart';
import 'package:kaiteki/fediverse/interfaces/search_support.dart';
import 'package:kaiteki/fediverse/services/notifications.dart';
import 'package:kaiteki/theming/kaiteki/text_theme.dart';
import 'package:kaiteki/ui/animation_functions.dart' as animations;
import 'package:kaiteki/ui/main/compose_fab.dart';
import 'package:kaiteki/ui/main/drawer.dart';
import 'package:kaiteki/ui/main/fab_data.dart';
import 'package:kaiteki/ui/main/pages/bookmarks.dart';
import 'package:kaiteki/ui/main/pages/notifications.dart';
import 'package:kaiteki/ui/main/pages/placeholder.dart';
import 'package:kaiteki/ui/main/pages/timeline.dart';
import 'package:kaiteki/ui/main/tab.dart';
import 'package:kaiteki/ui/main/tab_kind.dart';
import 'package:kaiteki/ui/shared/account_switcher_widget.dart';
import 'package:kaiteki/ui/shared/dialogs/keyboard_shortcuts_dialog.dart';
import 'package:kaiteki/ui/shortcuts/intents.dart';
import 'package:kaiteki/utils/extensions.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _timelineKey = GlobalKey<TimelinePageState>();
  List<MainScreenTab>? _tabs;
  TabKind _currentTab = TabKind.timeline;

  int get _currentIndex {
    return _tabs!.indexWhere((tab) => tab.kind == _currentTab);
  }

  List<MainScreenTab> getTabs(AppLocalizations l10n) {
    return [
      MainScreenTab(
        kind: TabKind.timeline,
        selectedIcon: Icons.home,
        icon: Icons.home_outlined,
        text: l10n.timelineTab,
        fab: FloatingActionButtonData(
          icon: Icons.edit_rounded,
          tooltip: l10n.composeDialogTitle,
          text: l10n.composeButtonLabel,
          onTap: () => context.showPostDialog(),
        ),
        hideFabWhenDesktop: true,
      ),
      MainScreenTab(
        kind: TabKind.notifications,
        selectedIcon: Icons.notifications_rounded,
        icon: Icons.notifications_none,
        text: l10n.notificationsTab,
        fetchUnreadCount: () {
          final account = ref.watch(accountProvider).current;

          if (account.adapter is! NotificationSupport) return null;

          final notifications = ref.watch(
            notificationServiceProvider(account.key),
          );

          return notifications.valueOrNull
              ?.where((n) => n.unread != false)
              .length;
        },
      ),
      MainScreenTab(
        kind: TabKind.chats,
        selectedIcon: Icons.forum,
        icon: Icons.forum_outlined,
        text: l10n.chatsTab,
      ),
      MainScreenTab(
        kind: TabKind.bookmarks,
        selectedIcon: Icons.bookmark_rounded,
        icon: Icons.bookmark_border_rounded,
        text: l10n.bookmarksTab,
      ),
    ];
  }

  static Color? getOutsideColor(BuildContext context) {
    if (Theme.of(context).useMaterial3) {
      return Theme.of(context).colorScheme.surfaceVariant;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();
    _tabs ??= getTabs(l10n);

    return FocusableActionDetector(
      actions: {
        NewPostIntent: CallbackAction(
          onInvoke: (_) => context.showPostDialog(),
        ),
        // SearchIntent: CallbackAction(
        //   onInvoke: (_) => _search?.call(),
        // ),
        RefreshIntent: CallbackAction(
          onInvoke: (_) => _refresh?.call(),
        ),
        GoToAppLocationIntent: CallbackAction<GoToAppLocationIntent>(
          onInvoke: _changeLocation,
        ),
        ShortcutsHelpIntent: CallbackAction(
          onInvoke: (_) => _showKeyboardShortcuts(),
        ),
      },
      child: BreakpointBuilder(
        builder: (_, breakpoint) {
          final isMobile = breakpoint.window == WindowSize.xsmall;
          final outsideColor = getOutsideColor(context);
          final tab = _tabs![_currentIndex];
          final fab = tab.fab;

          if (breakpoint.window == WindowSize.xsmall) {
            return Scaffold(
              key: _scaffoldKey,
              appBar: buildAppBar(outsideColor, context),
              body: _buildPage(),
              bottomNavigationBar: _getNavigationBar(),
              floatingActionButton:
                  fab != null ? _buildFab(context, fab, true) : null,
              drawer: const MainScreenDrawer(),
            );
          } else {
            return Scaffold(
              key: _scaffoldKey,
              backgroundColor: outsideColor,
              appBar: buildAppBar(outsideColor, context),
              body: _buildDesktopView(breakpoint.window >= WindowSize.medium),
              floatingActionButton: !tab.hideFabWhenDesktop && fab != null
                  ? _buildFab(context, fab, isMobile)
                  : null,
              drawer: const MainScreenDrawer(),
            );
          }
        },
      ),
    );
  }

  AppBar buildAppBar(Color? outsideColor, BuildContext context) {
    Color? foregroundColor;

    if (outsideColor != null) {
      foregroundColor = ThemeData.estimateBrightnessForColor(outsideColor)
          .inverted
          .getColor();
    }

    return AppBar(
      backgroundColor: outsideColor,
      foregroundColor: foregroundColor,
      title: Text(
        consts.appName,
        style: Theme.of(context).ktkTextTheme?.kaitekiTextStyle,
      ),
      elevation: Theme.of(context).useMaterial3 ? 0.0 : null,
      surfaceTintColor:
          Theme.of(context).useMaterial3 ? Colors.transparent : null,
      actions: _buildAppBarActions(context),
    );
  }

  Widget _buildDesktopView(bool extendNavRail) {
    final outsideColor = getOutsideColor(context);
    final m3 = Theme.of(context).useMaterial3;
    return Row(
      children: [
        Column(
          children: [
            Flexible(
              child: NavigationRail(
                backgroundColor: outsideColor,
                useIndicator: Theme.of(context).useMaterial3,
                selectedIndex: _currentIndex,
                onDestinationSelected: _changeIndex,
                extended: extendNavRail,
                // groupAlignment: consts.useM3 ? 0 : null,
                minWidth: m3 ? null : 56,
                leading: ComposeFloatingActionButton(
                  backgroundColor:
                      Theme.of(context).colorScheme.tertiaryContainer,
                  foregroundColor:
                      Theme.of(context).colorScheme.onTertiaryContainer,
                  type: extendNavRail
                      ? ComposeFloatingActionButtonType.extended
                      : ComposeFloatingActionButtonType.small,
                ),
                destinations: _navigationRailDestinations,
              ),
            ),
            // if (consts.useM3) SizedBox(height: extendNavRail ? 96 : 72),
          ],
        ),
        if (!m3) const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: _roundWidgetM3(context, _buildPage()),
        ),
      ],
    );
  }

  List<NavigationRailDestination> get _navigationRailDestinations {
    final destinations = <NavigationRailDestination>[];
    for (final tab in _tabs!) {
      final unreadCount = tab.fetchUnreadCount?.call();
      destinations.add(
        NavigationRailDestination(
          icon: _wrapInBadge(Icon(tab.icon), unreadCount),
          selectedIcon: Icon(tab.selectedIcon),
          label: Text(tab.text),
        ),
      );
    }
    return destinations;
  }

  VoidCallback? get _search {
    if (ref.watch(adapterProvider) is! SearchSupport) return null;
    return () {
      context.pushNamed("search", params: ref.accountRouterParams);
    };
  }

  VoidCallback? get _refresh {
    switch (_currentTab) {
      case TabKind.timeline:
        return _timelineKey.currentState?.refresh;

      case TabKind.notifications:
        final account = ref.watch(accountProvider).current.key;
        return ref.read(notificationServiceProvider(account).notifier).refresh;

      default:
        return null;
    }
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    final l10n = context.getL10n();

    return [
      IconButton(
        icon: const Icon(Icons.search_rounded),
        onPressed: _search,
        tooltip: l10n.searchButtonLabel,
      ),
      IconButton(
        icon: const Icon(Icons.refresh_rounded),
        onPressed: _refresh,
        tooltip: l10n.refreshTimelineButtonLabel,
      ),

      // TODO(ThatOneCalculator or Craftplacer): hide if Android
      PopupMenuButton<Function()>(
        onSelected: (v) => v.call(),
        itemBuilder: (_) {
          return [
            PopupMenuItem(
              value: _showKeyboardShortcuts,
              child: Text(l10n.keyboardShortcuts),
            ),
          ];
        },
      ),
      const AccountSwitcherWidget(size: 40),
    ];
  }

  Future<void> _showKeyboardShortcuts() async {
    await showDialog(
      context: context,
      builder: (_) => const KeyboardShortcutsDialog(),
    );
  }

  Widget _buildPage() {
    final pages = [
      TimelinePage(key: _timelineKey),
      const NotificationsPage(),
      const PlaceholderPage(),
      const BookmarksPage(),
    ];

    return PageTransitionSwitcher(
      transitionBuilder: animations.fadeThrough,
      child: pages[_currentIndex],
    );
  }

  static Widget _roundWidgetM3(BuildContext context, Widget widget) {
    if (!Theme.of(context).useMaterial3) return widget;

    const radius = Radius.circular(16.0);
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: radius,
        topRight: radius,
      ),
      child: widget,
    );
  }

  Widget? _getNavigationBar() {
    if (_tabs!.length < 2) {
      return null;
    }

    if (Theme.of(context).useMaterial3) {
      return NavigationBar(
        onDestinationSelected: _changeIndex,
        selectedIndex: _currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: _navigationDestinations,
      );
    } else {
      return BottomNavigationBar(
        onTap: _changeIndex,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: _bottomNavigationBarItems,
      );
    }
  }

  Widget _wrapInBadge(Widget child, int? number) {
    // HACK(Craftplacer): These are not the new Material You badges
    final labelSmall = Theme.of(context).textTheme.labelSmall;
    return Badge(
      showBadge: (number ?? 0) > 0,
      padding: EdgeInsets.zero,
      badgeContent: SizedBox.square(
        dimension: 16,
        child: Text(
          number?.toString() ?? "0",
          style: labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onError,
            height: (labelSmall.fontSize ?? 0) / 7,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      badgeColor: Theme.of(context).colorScheme.error,
      child: child,
    );
  }

  List<BottomNavigationBarItem> get _bottomNavigationBarItems {
    final bottomNavigationBarItems = <BottomNavigationBarItem>[];
    for (final tab in _tabs!) {
      final unreadCount = tab.fetchUnreadCount?.call();
      bottomNavigationBarItems.add(
        BottomNavigationBarItem(
          icon: _wrapInBadge(Icon(tab.icon), unreadCount),
          activeIcon: _wrapInBadge(Icon(tab.selectedIcon), unreadCount),
          label: tab.text,
        ),
      );
    }
    return bottomNavigationBarItems;
  }

  List<Widget> get _navigationDestinations {
    final navigationDestinations = <NavigationDestination>[];
    for (final tab in _tabs!) {
      final unreadCount = tab.fetchUnreadCount?.call();
      navigationDestinations.add(
        NavigationDestination(
          icon: _wrapInBadge(Icon(tab.icon), unreadCount),
          selectedIcon: _wrapInBadge(Icon(tab.selectedIcon), unreadCount),
          label: tab.text,
        ),
      );
    }
    return navigationDestinations;
  }

  void _changeIndex(int index) => _changePage(_tabs![index].kind);

  void _changePage(TabKind tab) => setState(() => _currentTab = tab);

  Widget? _buildFab(
    BuildContext context,
    FloatingActionButtonData data,
    bool mobile,
  ) {
    if (mobile) {
      return FloatingActionButton(
        tooltip: data.tooltip,
        onPressed: data.onTap,
        child: Icon(data.icon),
      );
    } else {
      return FloatingActionButton.extended(
        label: Text(data.text),
        icon: Icon(data.icon),
        onPressed: data.onTap,
      );
    }
  }

  dynamic _changeLocation(GoToAppLocationIntent i) {
    switch (i.location) {
      case AppLocation.home:
        _changePage(TabKind.timeline);
        break;
      case AppLocation.notifications:
        _changePage(TabKind.notifications);
        break;
      case AppLocation.bookmarks:
        _changePage(TabKind.bookmarks);
        break;
      case AppLocation.settings:
        context.push("/settings");
        break;
    }
    return null;
  }
}
