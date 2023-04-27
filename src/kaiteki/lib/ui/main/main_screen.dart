import "package:animations/animations.dart";
import "package:breakpoint/breakpoint.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/constants.dart" as consts;
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/interfaces/bookmark_support.dart";
import "package:kaiteki/fediverse/interfaces/chat_support.dart";
import "package:kaiteki/fediverse/interfaces/notification_support.dart";
import "package:kaiteki/fediverse/interfaces/search_support.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/fediverse/services/notifications.dart";
import "package:kaiteki/platform_checks.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";
import "package:kaiteki/ui/main/drawer.dart";
import "package:kaiteki/ui/main/fab_data.dart";
import "package:kaiteki/ui/main/navigation/navigation_bar.dart";
import "package:kaiteki/ui/main/navigation/navigation_rail.dart";
import "package:kaiteki/ui/main/pages/bookmarks.dart";
import "package:kaiteki/ui/main/pages/chats.dart";
import "package:kaiteki/ui/main/pages/notifications.dart";
import "package:kaiteki/ui/main/pages/timeline.dart";
import "package:kaiteki/ui/main/tab.dart";
import "package:kaiteki/ui/main/tab_kind.dart";
import "package:kaiteki/ui/main/views/catalog.dart";
import "package:kaiteki/ui/main/views/deck.dart";
import "package:kaiteki/ui/main/views/fox.dart";
import "package:kaiteki/ui/main/views/videos.dart";
import "package:kaiteki/ui/main/views/view.dart";
import "package:kaiteki/ui/shared/account_switcher_widget.dart";
import "package:kaiteki/ui/shared/dialogs/keyboard_shortcuts_dialog.dart";
import "package:kaiteki/ui/shortcuts/intents.dart";
import "package:kaiteki/utils/extensions.dart";

Widget _buildViewIcon(MainScreenViewType view) {
  switch (view) {
    case MainScreenViewType.stream:
      return const Icon(Icons.view_stream_rounded);
    case MainScreenViewType.deck:
      return const Icon(Icons.view_column_rounded);
    case MainScreenViewType.catalog:
      return const Icon(Icons.view_module_rounded);
    case MainScreenViewType.videos:
      return const Icon(Icons.videocam_rounded);
    case MainScreenViewType.fox:
      return Builder(
        builder: (context) {
          return Text(
            "🦊",
            style: TextStyle(fontSize: IconTheme.of(context).size! * 0.8),
          );
        },
      );
  }
}

String _getViewDisplayName(MainScreenViewType view) {
  switch (view) {
    case MainScreenViewType.stream:
      return "Stream";
    case MainScreenViewType.deck:
      return "Deck";
    case MainScreenViewType.catalog:
      return "Catalog";
    case MainScreenViewType.videos:
      return "Videos";
    case MainScreenViewType.fox:
      return "Fox";
  }
}

class MainScreen extends ConsumerStatefulWidget {
  @visibleForTesting
  final TimelineKind? initialTimeline;

  const MainScreen({super.key, this.initialTimeline});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

enum MainScreenViewType { stream, deck, catalog, videos, fox }

class _MainScreenState extends ConsumerState<MainScreen> {
  // Why does this exist? In order to refresh the timeline
  final _timelineKey = GlobalKey<TimelinePageState>();
  late List<MainScreenTab> _tabs;
  TabKind _currentTab = TabKind.home;
  MainScreenViewType _view = MainScreenViewType.stream;

  int get _currentIndex {
    final index = _tabs.indexWhere((tab) => tab.kind == _currentTab);
    return index == -1 ? 0 : index;
  }

  Color? get _outsideColor {
    final theme = Theme.of(context);
    if (theme.useMaterial3) return theme.colorScheme.surfaceVariant;
    return null;
  }

  VoidCallback? get _refresh {
    switch (_currentTab) {
      case TabKind.home:
        return _timelineKey.currentState?.refresh;

      case TabKind.notifications:
        final account = ref.watch(accountProvider)!.key;
        return ref.read(notificationServiceProvider(account).notifier).refresh;

      default:
        return null;
    }
  }

  VoidCallback? get _search {
    if (ref.watch(adapterProvider) is! SearchSupport) return null;
    return () {
      context.pushNamed("search", params: ref.accountRouterParams);
    };
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: ElevationOverlay.applySurfaceTint(
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surfaceTint,
          3,
        ),
        systemNavigationBarContrastEnforced: false,
      ),
    );

    _tabs = getTabs().map((e) => buildTabItem(context, e)).toList();

    final timeline = _buildTimeline(context);

    final body = PageTransitionSwitcher(
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
        return FadeThroughTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          child: Material(child: child),
        );
      },
      child: {
        TabKind.home: timeline,
        TabKind.notifications: const NotificationsPage(),
        TabKind.chats: const ChatsPage(),
        TabKind.bookmarks: const BookmarksPage(),
      }[_currentTab],
    );

    return FocusableActionDetector(
      autofocus: true,
      actions: {
        NewPostIntent: CallbackAction(onInvoke: (_) => _onCompose()),
        SearchIntent: CallbackAction(
          onInvoke: (_) => _search?.call(),
        ),
        RefreshIntent: CallbackAction(onInvoke: (_) => _refresh?.call()),
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
          final tab = _tabs[_currentIndex];
          final fab = tab.fab;

          final hideNavigation = _view == MainScreenViewType.fox;
          final hideBottomBar = _tabs.length < 2 ||
              _view == MainScreenViewType.videos ||
              hideNavigation;
          final hideFab = fab == null || _view == MainScreenViewType.videos;
          final immerse = !hideNavigation;

          Widget? floatingActionButton, bottomNavigationBar;

          NavigationVisibility? navigationVisibility;

          if (_currentTab == TabKind.home && timeline is MainScreenView) {
            navigationVisibility =
                (timeline as MainScreenView).navigationVisibility;
          }

          navigationVisibility ??= breakpoint.window < WindowSize.large
              ? NavigationVisibility.compact
              : NavigationVisibility.normal;

          if (isMobile && !hideBottomBar) {
            bottomNavigationBar = MainScreenNavigationBar(
              tabs: _tabs,
              currentIndex: _currentIndex,
              onChangeIndex: _changeIndex,
            );
          }

          if (!hideFab && !(tab.hideFabWhenDesktop && !isMobile)) {
            floatingActionButton = _buildFab(context, fab, isMobile);
          }

          if (isMobile) {
            return Scaffold(
              appBar: _buildAppBar(context, false),
              body: body,
              bottomNavigationBar: bottomNavigationBar,
              floatingActionButton: floatingActionButton,
              drawer: const MainScreenDrawer(),
            );
          } else {
            return Scaffold(
              backgroundColor: _outsideColor,
              appBar: _buildAppBar(context, immerse),
              body: _buildDesktopView(navigationVisibility, immerse, body),
              floatingActionButton: floatingActionButton,
              drawer: const MainScreenDrawer(),
            );
          }
        },
      ),
    );
  }

  MainScreenTab buildTabItem(BuildContext context, TabKind kind) {
    final l10n = context.l10n;

    switch (kind) {
      case TabKind.home:
        return MainScreenTab(
          TabKind.home,
          fab: FloatingActionButtonData(
            icon: Icons.edit_rounded,
            tooltip: l10n.composeDialogTitle,
            text: l10n.composeButtonLabel,
            onTap: _onCompose,
          ),
          hideFabWhenDesktop: true,
        );
      case TabKind.notifications:
        return MainScreenTab(
          TabKind.notifications,
          fetchUnreadCount: _fetchNotificationCount,
        );
      case TabKind.chats:
        return const MainScreenTab(TabKind.chats);
      case TabKind.bookmarks:
        return const MainScreenTab(TabKind.bookmarks);
    }
  }

  Set<TabKind> getTabs() {
    final adapter = ref.watch(adapterProvider);
    final supportsNotifications = adapter is NotificationSupport;
    final supportsChats =
        adapter.safeCast<ChatSupport>()?.capabilities.supportsChat ?? false;
    final supportsBookmarks = adapter is BookmarkSupport;

    return {
      TabKind.home,
      if (supportsNotifications) TabKind.notifications,
      if (supportsChats) TabKind.chats,
      if (supportsBookmarks) TabKind.bookmarks,
    };
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool immerse) {
    if (ref.watch(useSearchBar).value) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(56.0 + 8.0 * 2),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchBar(
            focusNode: FocusNode(canRequestFocus: false, skipTraversal: true),
            onTap: () => context.pushNamed(
              "search",
              params: ref.accountRouterParams,
            ),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            leading: const DrawerButton(),
            hintText: "Search",
            trailing: const [
              AccountSwitcherWidget(size: 30),
            ],
          ),
        ),
      );
    }

    Color? foregroundColor;

    final outsideColor = immerse ? _outsideColor : null;
    if (outsideColor != null) {
      foregroundColor = ThemeData.estimateBrightnessForColor(outsideColor)
          .inverted
          .getColor();
    }

    final theme = Theme.of(context);
    final elevation = theme.useMaterial3 ? 0.0 : null;
    return AppBar(
      backgroundColor: outsideColor,
      foregroundColor: foregroundColor,
      title: Text(
        consts.appName,
        style: theme.ktkTextTheme?.kaitekiTextStyle,
      ),
      actions: _buildAppBarActions(context),
      scrolledUnderElevation: immerse ? elevation : null,
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    final l10n = context.l10n;

    return [
      if (_currentTab == TabKind.home &&
          ref.watch(AppExperiment.timelineViews.provider))
        PopupMenuButton<MainScreenViewType>(
          initialValue: _view,
          icon: _buildViewIcon(_view),
          tooltip: "View",
          onSelected: (view) => setState(() => _view = view),
          itemBuilder: (context) {
            return [
              for (final view in MainScreenViewType.values)
                PopupMenuItem(
                  value: view,
                  enabled: !(view == MainScreenViewType.videos &&
                      !supportsVideoPlayer),
                  child: ListTile(
                    leading: _buildViewIcon(view),
                    title: Text(_getViewDisplayName(view)),
                    contentPadding: EdgeInsets.zero,
                    enabled: !(view == MainScreenViewType.videos &&
                        !supportsVideoPlayer),
                  ),
                ),
            ];
          },
        ),
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

      // TODO(Craftplacer): hide if no keyboard is detected
      PopupMenuButton(
        itemBuilder: (_) => [
          PopupMenuItem(
            onTap: _showKeyboardShortcuts,
            child: Text(l10n.keyboardShortcuts),
          ),
        ],
      ),
      const AccountSwitcherWidget(size: 40),
    ];
  }

  Widget _buildDesktopView(
    NavigationVisibility navigationRail,
    bool immerse,
    Widget child,
  ) {
    final m3 = Theme.of(context).useMaterial3;
    final tabCount = _tabs.length;
    return Row(
      children: [
        if (navigationRail != NavigationVisibility.hide && tabCount >= 2) ...[
          _buildNavigationRail(navigationRail == NavigationVisibility.normal),
          if (!m3) const VerticalDivider(thickness: 1, width: 1),
        ],
        Expanded(child: immerse ? _roundWidget(context, child) : child),
      ],
    );
  }

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

  Widget _buildNavigationRail(bool extend) {
    return MainScreenNavigationRail(
      tabs: _tabs,
      currentIndex: _currentIndex,
      onChangeIndex: _changeIndex,
      extended: extend,
      backgroundColor: _outsideColor,
    );
  }

  Widget _buildTimeline(BuildContext context) {
    switch (_view) {
      case MainScreenViewType.stream:
        return TimelinePage(
          key: _timelineKey,
          initialTimeline: widget.initialTimeline,
        );
      case MainScreenViewType.deck:
        return const DeckMainScreenView();
      case MainScreenViewType.catalog:
        return const CatalogMainScreenView();
      case MainScreenViewType.videos:
        return const VideoMainScreenView();
      case MainScreenViewType.fox:
        return const FoxMainScreenView();
    }
  }

  void _changeIndex(int index) => _changePage(_tabs[index].kind);

  dynamic _changeLocation(GoToAppLocationIntent i) {
    switch (i.location) {
      case AppLocation.home:
        _changePage(TabKind.home);
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
      default:
        return null;
    }
  }

  void _changePage(TabKind tab) => setState(() => _currentTab = tab);

  int? _fetchNotificationCount() {
    final account = ref.watch(accountProvider);

    if (account == null) return null;
    if (account.adapter is! NotificationSupport) return null;

    final notifications = ref.watch(notificationServiceProvider(account.key));
    return notifications.valueOrNull?.where((n) => n.unread != false).length;
  }

  void _onCompose() => context.pushNamed(
        "compose",
        params: ref.accountRouterParams,
      );

  Future<void> _showKeyboardShortcuts() async {
    await showDialog(
      context: context,
      builder: (_) => const KeyboardShortcutsDialog(),
    );
  }

  static Widget _roundWidget(BuildContext context, Widget widget) {
    if (!Theme.of(context).useMaterial3) return widget;

    const radius = Radius.circular(16.0);
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: radius),
      child: widget,
    );
  }
}
