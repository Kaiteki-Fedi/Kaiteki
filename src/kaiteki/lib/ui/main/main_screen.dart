import 'package:animations/animations.dart';
import 'package:breakpoint/breakpoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/interfaces/notification_support.dart';
import 'package:kaiteki/fediverse/interfaces/search_support.dart';
import 'package:kaiteki/fediverse/model/model.dart';
import 'package:kaiteki/fediverse/services/notifications.dart';
import 'package:kaiteki/platform_checks.dart';
import 'package:kaiteki/preferences/app_experiment.dart';
import 'package:kaiteki/theming/kaiteki/text_theme.dart';
import 'package:kaiteki/ui/main/drawer.dart';
import 'package:kaiteki/ui/main/fab_data.dart';
import 'package:kaiteki/ui/main/navigation/navigation_bar.dart';
import 'package:kaiteki/ui/main/navigation/navigation_rail.dart';
import 'package:kaiteki/ui/main/pages/bookmarks.dart';
import 'package:kaiteki/ui/main/pages/notifications.dart';
import 'package:kaiteki/ui/main/pages/placeholder.dart';
import 'package:kaiteki/ui/main/pages/timeline.dart';
import 'package:kaiteki/ui/main/tab.dart';
import 'package:kaiteki/ui/main/tab_kind.dart';
import 'package:kaiteki/ui/main/views/catalog.dart';
import 'package:kaiteki/ui/main/views/deck.dart';
import 'package:kaiteki/ui/main/views/fox.dart';
import 'package:kaiteki/ui/main/views/videos.dart';
import 'package:kaiteki/ui/shared/account_switcher_widget.dart';
import 'package:kaiteki/ui/shared/dialogs/keyboard_shortcuts_dialog.dart';
import 'package:kaiteki/ui/shortcuts/intents.dart';
import 'package:kaiteki/utils/extensions.dart';

class MainScreen extends ConsumerStatefulWidget {
  @visibleForTesting
  final TimelineKind? initialTimeline;

  const MainScreen({super.key, this.initialTimeline});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  // Why does this exist? In order to refresh the timeline
  final _timelineKey = GlobalKey<TimelinePageState>();
  List<MainScreenTab>? _tabs;
  TabKind _currentTab = TabKind.home;
  MainScreenView _view = MainScreenView.stream;

  int get _currentIndex {
    return _tabs!.indexWhere((tab) => tab.kind == _currentTab);
  }

  List<MainScreenTab> getTabs(AppLocalizations l10n) {
    return [
      MainScreenTab(
        kind: TabKind.home,
        selectedIcon: Icons.home,
        icon: Icons.home_outlined,
        text: l10n.timelineTab,
        fab: FloatingActionButtonData(
          icon: Icons.edit_rounded,
          tooltip: l10n.composeDialogTitle,
          text: l10n.composeButtonLabel,
          onTap: _onCompose,
        ),
        hideFabWhenDesktop: true,
      ),
      MainScreenTab(
        kind: TabKind.notifications,
        selectedIcon: Icons.notifications_rounded,
        icon: Icons.notifications_none,
        text: l10n.notificationsTab,
        fetchUnreadCount: _fetchNotificationCount,
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

  int? _fetchNotificationCount() {
    final account = ref.watch(accountProvider)!;

    if (account.adapter is! NotificationSupport) return null;

    final notifications = ref.watch(
      notificationServiceProvider(account.key),
    );

    return notifications.valueOrNull?.where((n) => n.unread != false).length;
  }

  Color? get _outsideColor {
    final theme = Theme.of(context);
    if (theme.useMaterial3) return theme.colorScheme.surfaceVariant;
    return null;
  }

  Widget _buildTimeline(BuildContext context) {
    switch (_view) {
      case MainScreenView.stream:
        return TimelinePage(
          key: _timelineKey,
          initialTimeline: widget.initialTimeline,
        );
      case MainScreenView.deck:
        return const DeckMainScreenView();
      case MainScreenView.catalog:
        return const CatalogMainScreenView();
      case MainScreenView.videos:
        return const VideoMainScreenView();
      case MainScreenView.fox:
        return const FoxMainScreenView();
    }
  }

  void _onCompose() => context.pushNamed(
        "compose",
        params: ref.accountRouterParams,
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    _tabs ??= getTabs(l10n);

    final body = PageTransitionSwitcher(
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
        return FadeThroughTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      child: [
        _buildTimeline(context),
        const NotificationsPage(),
        const PlaceholderPage(),
        const BookmarksPage(),
      ][_currentIndex],
    );

    return FocusableActionDetector(
      autofocus: true,
      actions: {
        NewPostIntent: CallbackAction(onInvoke: (_) => _onCompose()),
        // SearchIntent: CallbackAction(
        //   onInvoke: (_) => _search?.call(),
        // ),
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
          final outsideColor = _outsideColor;
          final tab = _tabs![_currentIndex];
          final fab = tab.fab;

          final hideNavigation = _view == MainScreenView.fox;
          final hideBottomBar = _tabs!.length < 2 ||
              _view == MainScreenView.videos ||
              hideNavigation;
          final hideFab = fab == null || _view == MainScreenView.videos;

          if (isMobile) {
            return Scaffold(
              appBar: _buildAppBar(context, false),
              body: body,
              bottomNavigationBar: hideBottomBar
                  ? null
                  : MainScreenNavigationBar(
                      tabs: _tabs!,
                      currentIndex: _currentIndex,
                      onChangeIndex: _changeIndex,
                    ),
              floatingActionButton:
                  hideFab ? null : _buildFab(context, fab, true),
              drawer: const MainScreenDrawer(),
            );
          } else {
            return Scaffold(
              backgroundColor: outsideColor,
              appBar: _buildAppBar(context, true),
              body: _buildDesktopView(
                hideNavigation,
                breakpoint.window >= WindowSize.medium &&
                    !((_view == MainScreenView.deck ||
                            _view == MainScreenView.fox) &&
                        _currentTab == TabKind.home),
                body,
              ),
              floatingActionButton: tab.hideFabWhenDesktop || hideFab
                  ? null
                  : _buildFab(context, fab, isMobile),
              drawer: const MainScreenDrawer(),
            );
          }
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, bool disableScrollElevation) {
    Color? foregroundColor;

    final outsideColor = _outsideColor;
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
      elevation: elevation,
      surfaceTintColor: theme.useMaterial3 ? Colors.transparent : null,
      actions: _buildAppBarActions(context),
      scrolledUnderElevation: disableScrollElevation ? elevation : null,
    );
  }

  static Widget _buildViewIcon(MainScreenView view) {
    switch (view) {
      case MainScreenView.stream:
        return const Icon(Icons.view_stream_rounded);
      case MainScreenView.deck:
        return const Icon(Icons.view_column_rounded);
      case MainScreenView.catalog:
        return const Icon(Icons.view_module_rounded);
      case MainScreenView.videos:
        return const Icon(Icons.videocam_rounded);
      case MainScreenView.fox:
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

  static String _getViewDisplayName(MainScreenView view) {
    switch (view) {
      case MainScreenView.stream:
        return "Stream";
      case MainScreenView.deck:
        return "Deck";
      case MainScreenView.catalog:
        return "Catalog";
      case MainScreenView.videos:
        return "Videos";
      case MainScreenView.fox:
        return "Fox";
    }
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    final l10n = context.l10n;
    final experiments =
        ref.watch(preferencesProvider.select((p) => p.enabledExperiments));

    return [
      if (_currentTab == TabKind.home &&
          experiments.contains(AppExperiment.timelineViews))
        PopupMenuButton<MainScreenView>(
          initialValue: _view,
          icon: _buildViewIcon(_view),
          tooltip: "View",
          onSelected: (view) => setState(() => _view = view),
          itemBuilder: (context) {
            return [
              for (final view in MainScreenView.values)
                PopupMenuItem(
                  value: view,
                  enabled:
                      !(view == MainScreenView.videos && !supportsVideoPlayer),
                  child: ListTile(
                    leading: _buildViewIcon(view),
                    title: Text(_getViewDisplayName(view)),
                    contentPadding: EdgeInsets.zero,
                    enabled: !(view == MainScreenView.videos &&
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

  Widget _buildNavigationRail(bool extend) {
    return MainScreenNavigationRail(
      tabs: _tabs!,
      currentIndex: _currentIndex,
      onChangeIndex: _changeIndex,
      extended: extend,
      backgroundColor: _outsideColor,
    );
  }

  Widget _buildDesktopView(bool hideNavRail, bool extendNavRail, Widget child) {
    final m3 = Theme.of(context).useMaterial3;
    return Row(
      children: [
        if (!hideNavRail) ...[
          _buildNavigationRail(extendNavRail),
          if (!m3) const VerticalDivider(thickness: 1, width: 1),
        ],
        Expanded(child: _roundWidgetM3(context, child)),
      ],
    );
  }

  VoidCallback? get _search {
    if (ref.watch(adapterProvider) is! SearchSupport) return null;
    return () {
      context.pushNamed("search", params: ref.accountRouterParams);
    };
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

  Future<void> _showKeyboardShortcuts() async {
    await showDialog(
      context: context,
      builder: (_) => const KeyboardShortcutsDialog(),
    );
  }

  static Widget _roundWidgetM3(BuildContext context, Widget widget) {
    if (!Theme.of(context).useMaterial3) return widget;

    const radius = Radius.circular(16.0);
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: radius),
      child: widget,
    );
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
    }
    return null;
  }
}

enum MainScreenView { stream, deck, catalog, videos, fox }
