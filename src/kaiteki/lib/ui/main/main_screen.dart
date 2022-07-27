import 'package:animations/animations.dart';
import 'package:breakpoint/breakpoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/timeline_kind.dart';
import 'package:kaiteki/ui/animation_functions.dart' as animations;
import 'package:kaiteki/ui/main/compose_fab.dart';
import 'package:kaiteki/ui/main/fab_data.dart';
import 'package:kaiteki/ui/main/pages/bookmarks.dart';
import 'package:kaiteki/ui/main/pages/placeholder.dart';
import 'package:kaiteki/ui/main/pages/timeline.dart';
import 'package:kaiteki/ui/main/tab.dart';
import 'package:kaiteki/ui/main/tab_kind.dart';
import 'package:kaiteki/ui/main/timeline_bottom_sheet.dart';
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
  TimelineKind _timelineKind = TimelineKind.home;
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
              backgroundColor: outsideColor,
              appBar: buildAppBar(outsideColor, context),
              body: _getPage(),
              bottomNavigationBar: _getNavigationBar(),
              floatingActionButton:
                  fab != null ? _buildFab(context, fab, true) : null,
              drawer: _buildDrawer(context),
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
              drawer: _buildDrawer(context),
            );
          }
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final handle = ref.getCurrentAccountHandle();
    final l10n = context.getL10n();
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 16.0,
              ),
              child: Text(
                "Kaiteki",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            ..._tabs!.map((tab) => _buildDrawerTab(context, tab)),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.flag_rounded),
              title: Text(l10n.reportsTitle),
              onTap: () => context.push("/$handle/reports"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.manage_accounts_rounded),
              title: Text(l10n.accountSettingsTitle),
              onTap: () => context.push("/$handle/settings"),
            ),
            ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: Text(l10n.settings),
              onTap: () => context.push("/settings"),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: Text(l10n.settingsAbout),
              onTap: () => context.push("/about"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerTab(BuildContext context, MainScreenTab tab) {
    final selected = _currentTab == tab.kind;
    return ListTile(
      leading: selected //
          ? Icon(tab.selectedIcon)
          : Icon(tab.icon),
      title: Text(tab.text),
      selected: selected,
      onTap: () {
        setState(() => _currentTab = tab.kind);
        Navigator.pop(context);
      },
    );
  }

  AppBar buildAppBar(Color? outsideColor, BuildContext context) {
    return AppBar(
      backgroundColor: outsideColor,
      foregroundColor: outsideColor != null
          ? ThemeData.estimateBrightnessForColor(outsideColor)
              .inverted
              .getColor()
          : null,
      title: Text(
        consts.appName,
        style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
      ),
      elevation: Theme.of(context).useMaterial3 ? 0.0 : null,
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
                destinations: [
                  for (var tab in _tabs!)
                    NavigationRailDestination(
                      icon: Icon(tab.icon),
                      selectedIcon: Icon(tab.selectedIcon),
                      label: Text(tab.text),
                    ),
                ],
              ),
            ),
            // if (consts.useM3) SizedBox(height: extendNavRail ? 96 : 72),
          ],
        ),
        if (!m3) const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: _roundWidgetM3(context, _getPage()),
        ),
      ],
    );
  }

  Function()? get _refresh {
    if (_currentTab == TabKind.timeline) {
      return () => _timelineKey.currentState?.refresh();
    }

    return null;
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    final l10n = context.getL10n();

    return [
      IconButton(
        icon: const Icon(Icons.refresh_rounded),
        onPressed: _refresh,
        tooltip: l10n.refreshTimelineButtonLabel,
      ),
      PopupMenuButton<Function()>(
        onSelected: (v) => v.call(),
        itemBuilder: (_) {
          return [
            PopupMenuItem(
              value: _showKeyboardShortcuts,
              child: const Text("Keyboard Shortcuts"),
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

  Widget _getPage() {
    final pages = [
      TimelinePage(_timelineKind, key: _timelineKey),
      const PlaceholderPage(),
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
        destinations: [
          for (var tab in _tabs!)
            NavigationDestination(
              icon: Icon(tab.icon),
              selectedIcon: Icon(tab.selectedIcon),
              label: tab.text,
            ),
        ],
      );
    } else {
      return BottomNavigationBar(
        onTap: _changeIndex,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          for (var tab in _tabs!)
            BottomNavigationBarItem(
              icon: Icon(tab.icon),
              activeIcon: Icon(tab.selectedIcon),
              label: tab.text,
            ),
        ],
      );
    }
  }

  Future<void> _changeIndex(int index) async {
    await _changePage(_tabs![index].kind);
  }

  Future<void> _changePage(TabKind tab) async {
    final isSamePage = _currentTab == tab;

    if (isSamePage && _currentTab == TabKind.timeline) {
      final timelineType = await showModalBottomSheet<TimelineKind?>(
        context: context,
        constraints: consts.bottomSheetConstraints,
        builder: (context) => TimelineBottomSheet(_timelineKind),
      );

      if (timelineType != null) {
        setState(() => _timelineKind = timelineType);
      }
      return;
    }

    setState(() => _currentTab = tab);
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
