import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/ui/animation_functions.dart' as animations;
import 'package:kaiteki/ui/intents.dart';
import 'package:kaiteki/ui/pages/timeline_page.dart';
import 'package:kaiteki/ui/shortcut_keys.dart';
import 'package:kaiteki/ui/widgets/account_switcher_widget.dart';
import 'package:kaiteki/ui/widgets/icon_landing_widget.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:mdi/mdi.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _timelineKey = UniqueKey();
  List<Widget>? _pages;
  List<_MainScreenTab>? _tabs;
  var _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appName = "Kaiteki";
    final l10n = AppLocalizations.of(context)!;

    _tabs ??= [
      _MainScreenTab(
        selectedIcon: Icons.home,
        icon: Icons.home_outlined,
        text: l10n.timelineTab,
        fab: _FloatingActionButtonData(
          icon: Mdi.pencil,
          tooltip: l10n.composeDialogTitle,
          text: l10n.composeButtonLabel,
          onTap: () => context.showPostDialog(),
        ),
      ),
      _MainScreenTab(
        selectedIcon: Icons.notifications_rounded,
        icon: Icons.notifications_none,
        text: l10n.notificationsTab,
        //fabTooltip: "Mark all as read",
        //fabText: "Read",
        //fabIcon: Mdi.checkAll,
        //fabOnTap: () {},
      ),
      _MainScreenTab(
        selectedIcon: Icons.forum,
        icon: Icons.forum_outlined,
        text: l10n.chatsTab,
      ),
    ];

    _pages ??= [
      TimelinePage(key: _timelineKey),
      Center(
        child: IconLandingWidget(
          icon: const Icon(Mdi.dotsHorizontal),
          text: Text(l10n.niy),
        ),
      ),
      Center(
        child: IconLandingWidget(
          icon: const Icon(Mdi.dotsHorizontal),
          text: Text(l10n.niy),
        ),
      ),
    ];

    return FocusableActionDetector(
      shortcuts: {
        ShortcutKeys.newPostKeySet: NewPostIntent(),
      },
      actions: {
        NewPostIntent: CallbackAction(
          onInvoke: (e) => context.showPostDialog(),
        ),
      },
      child: LayoutBuilder(
        builder: (_, constraints) {
          var desktopMode = Constants.desktopThreshold <= constraints.maxWidth;
          if (desktopMode) {
            return _buildDesktopView(appName);
          } else {
            return _buildMobileView(appName);
          }
        },
      ),
    );
  }

  Widget _buildDesktopView(String appName) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appName,
          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
        ),
        actions: _buildAppBarActions(context),
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _currentPage,
            onDestinationSelected: (x) => changePage(x),
            extended: false,
            labelType: NavigationRailLabelType.none,
            minWidth: 56,
            leading: _buildComposeFab(context),
            destinations: [
              for (var tab in _tabs!)
                NavigationRailDestination(
                  icon: Icon(tab.icon),
                  selectedIcon: Icon(tab.selectedIcon),
                  label: Text(tab.text),
                ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: _getPage()),
        ],
      ),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return [
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () => Navigator.of(context).pushNamed("/settings"),
        tooltip: l10n.settings,
      ),
      const AccountSwitcherWidget(size: 40),
    ];
  }

  Widget _buildMobileView(String appName) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appName,
          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
        ),
        actions: _buildAppBarActions(context),
      ),
      body: _getPage(),
      bottomNavigationBar: getNavigationBar(),
      floatingActionButton: getFab(context, _currentPage, false),
    );
  }

  Iterable<Widget> getTabListItems() {
    var i = 0;

    return _tabs!.map((tab) {
      var x = i;

      i++;

      return ListTile(
        leading: Icon(tab.selectedIcon),
        title: Text(tab.text),
        selected: _currentPage == x,
        onTap: () => changePage(x),
      );
    });
  }

  _getPage() {
    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: animations.fadeThrough,
      child: _pages![_currentPage],
    );
  }

  BottomNavigationBar? getNavigationBar() {
    if (_tabs!.length < 2) {
      return null;
    }

    return BottomNavigationBar(
      onTap: changePage,
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

  void changePage(int index) => setState(() => _currentPage = index);

  Widget _buildComposeFab(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: () => context.showPostDialog(),
      child: const Icon(Icons.edit_rounded),
      elevation: 4.0,
    );
  }

  Widget? getFab(BuildContext context, int index, bool desktop) {
    final tab = _tabs![_currentPage];
    final fab = tab.fab;

    if (fab == null) {
      return null;
    }

    if (desktop) {
      return FloatingActionButton.extended(
        label: Text(fab.text),
        icon: Icon(fab.icon),
        onPressed: fab.onTap,
      );
    } else {
      return FloatingActionButton(
        tooltip: fab.tooltip,
        child: Icon(fab.icon),
        onPressed: fab.onTap,
      );
    }
  }
}

class _MainScreenTab {
  final String text;
  final IconData selectedIcon;
  final IconData icon;
  final _FloatingActionButtonData? fab;

  const _MainScreenTab({
    required this.selectedIcon,
    required this.text,
    required this.icon,
    this.fab,
  });
}

class _FloatingActionButtonData {
  final VoidCallback? onTap;
  final String tooltip;
  final String text;
  final IconData icon;

  _FloatingActionButtonData({
    this.onTap,
    required this.tooltip,
    required this.text,
    required this.icon,
  });
}
