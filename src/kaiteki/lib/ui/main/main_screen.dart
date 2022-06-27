import 'package:animations/animations.dart';
import 'package:breakpoint/breakpoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/di.dart';
import 'package:kaiteki/ui/animation_functions.dart' as animations;
import 'package:kaiteki/ui/intents.dart';
import 'package:kaiteki/ui/main/bookmarks_page.dart';
import 'package:kaiteki/ui/main/compose_fab.dart';
import 'package:kaiteki/ui/main/fab_data.dart';
import 'package:kaiteki/ui/main/tab.dart';
import 'package:kaiteki/ui/main/timeline_page.dart';
import 'package:kaiteki/ui/shared/account_switcher_widget.dart';
import 'package:kaiteki/ui/shared/icon_landing_widget.dart';
import 'package:kaiteki/ui/shortcut_keys.dart';
import 'package:kaiteki/utils/extensions.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final _timelineKey = UniqueKey();
  List<Widget>? _pages;
  List<MainScreenTab>? _tabs;
  int _currentPage = 0;

  // TODO(Craftplacer): abstract this tab system a bit more and use enums to declare tab positioning, this allows us to later
  List<Widget> getPages(AppLocalizations l10n) {
    return [
      TimelinePage(key: _timelineKey),
      Center(
        child: IconLandingWidget(
          icon: const Icon(Icons.more_horiz_rounded),
          text: Text(l10n.niy),
        ),
      ),
      Center(
        child: IconLandingWidget(
          icon: const Icon(Icons.more_horiz_rounded),
          text: Text(l10n.niy),
        ),
      ),
      const BookmarksPage(),
    ];
  }

  List<MainScreenTab> getTabs(AppLocalizations l10n) {
    return [
      MainScreenTab(
        index: 0,
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
        index: 1,
        selectedIcon: Icons.notifications_rounded,
        icon: Icons.notifications_none,
        text: l10n.notificationsTab,
      ),
      MainScreenTab(
        index: 2,
        selectedIcon: Icons.forum,
        icon: Icons.forum_outlined,
        text: l10n.chatsTab,
      ),
      MainScreenTab(
        index: 3,
        selectedIcon: Icons.bookmark_rounded,
        icon: Icons.bookmark_border_rounded,
        text: l10n.bookmarksTab,
      ),
    ];
  }

  static Color? getOutsideColor(BuildContext context) {
    if (consts.useM3) {
      return Theme.of(context).colorScheme.surfaceVariant;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();
    _tabs ??= getTabs(l10n);
    _pages ??= getPages(l10n);

    return FocusableActionDetector(
      shortcuts: {newPostKeySet: NewPostIntent()},
      actions: {
        NewPostIntent: CallbackAction(
          onInvoke: (e) => context.showPostDialog(),
        ),
      },
      child: BreakpointBuilder(
        builder: (_, breakpoint) {
          final isMobile = breakpoint.window == WindowSize.xsmall;
          final outsideColor = getOutsideColor(context);

          if (breakpoint.window == WindowSize.xsmall) {
            return Scaffold(
              backgroundColor: outsideColor,
              appBar: buildAppBar(outsideColor, context),
              body: _getPage(),
              bottomNavigationBar: _getNavigationBar(),
              floatingActionButton: _getFab(context, _currentPage, true),
              drawer: _buildDrawer(context),
            );
          } else {
            final showFab = !_tabs![_currentPage].hideFabWhenDesktop;
            return Scaffold(
              backgroundColor: outsideColor,
              appBar: buildAppBar(outsideColor, context),
              body: _buildDesktopView(breakpoint.window >= WindowSize.medium),
              floatingActionButton:
                  showFab ? _getFab(context, _currentPage, isMobile) : null,
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
    return ListTile(
      leading: _currentPage == tab.index //
          ? Icon(tab.selectedIcon)
          : Icon(tab.icon),
      title: Text(tab.text),
      selected: _currentPage == tab.index,
      onTap: () {
        setState(() {
          _currentPage = tab.index;
        });
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
      elevation: consts.useM3 ? 0.0 : null,
      actions: _buildAppBarActions(context),
    );
  }

  Widget _buildDesktopView(bool extendNavRail) {
    final outsideColor = getOutsideColor(context);
    return Row(
      children: [
        Column(
          children: [
            Flexible(
              child: NavigationRail(
                backgroundColor: outsideColor,
                useIndicator: consts.useM3,
                selectedIndex: _currentPage,
                onDestinationSelected: _changePage,
                labelType: extendNavRail
                    ? NavigationRailLabelType.none
                    : NavigationRailLabelType.selected,
                extended: extendNavRail,
                // groupAlignment: consts.useM3 ? 0 : null,
                minWidth: consts.useM3 ? null : 56,
                leading: ComposeFloatingActionButton(
                  type: extendNavRail
                      ? ComposeFloatingActionButtonType.extended
                      : ComposeFloatingActionButtonType.small,
                  elevate: !consts.useM3,
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
        if (!consts.useM3) const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: _roundWidgetM3(_getPage()),
        ),
      ],
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    final l10n = context.getL10n();

    return [
      IconButton(
        icon: const Icon(Icons.refresh_rounded),
        onPressed: null,
        tooltip: l10n.refreshTimelineButtonLabel,
      ),
      const AccountSwitcherWidget(size: 40),
    ];
  }

  Widget _getPage() {
    return PageTransitionSwitcher(
      transitionBuilder: animations.fadeThrough,
      child: _pages![_currentPage],
    );
  }

  static Widget _roundWidgetM3(Widget widget) {
    if (!consts.useM3) return widget;

    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(16.0)),
      child: widget,
    );
  }

  Widget? _getNavigationBar() {
    if (_tabs!.length < 2) {
      return null;
    }

    if (consts.useM3) {
      return NavigationBar(
        onDestinationSelected: _changePage,
        selectedIndex: _currentPage,
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
        onTap: _changePage,
        currentIndex: _currentPage,
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

  void _changePage(int index) => setState(() => _currentPage = index);

  Widget? _getFab(BuildContext context, int index, bool mobile) {
    final tab = _tabs![_currentPage];
    final fab = tab.fab;

    if (fab == null) {
      return null;
    }

    if (mobile) {
      return FloatingActionButton(
        tooltip: fab.tooltip,
        onPressed: fab.onTap,
        child: Icon(fab.icon),
      );
    } else {
      return FloatingActionButton.extended(
        label: Text(fab.text),
        icon: Icon(fab.icon),
        onPressed: fab.onTap,
      );
    }
  }
}
