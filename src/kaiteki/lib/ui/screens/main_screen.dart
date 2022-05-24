import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/di.dart';
import 'package:kaiteki/ui/animation_functions.dart' as animations;
import 'package:kaiteki/ui/intents.dart';
import 'package:kaiteki/ui/pages/timeline_page.dart';
import 'package:kaiteki/ui/shortcut_keys.dart';
import 'package:kaiteki/ui/widgets/account_switcher_widget.dart';
import 'package:kaiteki/ui/widgets/icon_landing_widget.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:kaiteki/utils/layout_helper.dart';
import 'package:mdi/mdi.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _timelineKey = UniqueKey();
  List<Widget>? _pages;
  List<_MainScreenTab>? _tabs;
  int _currentPage = 0;

  // TODO(Craftplacer): abstract this tab system a bit more and use enums to declare tab positioning, this allows us to later
  List<Widget> getPages(AppLocalizations l10n) {
    return [
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
  }

  List<_MainScreenTab> getTabs(AppLocalizations l10n) {
    return [
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
      ),
      _MainScreenTab(
        selectedIcon: Icons.forum,
        icon: Icons.forum_outlined,
        text: l10n.chatsTab,
      ),
    ];
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
      child: LayoutBuilder(
        builder: (_, constraints) {
          final isMobile = getScreenSize(constraints.maxWidth) == ScreenSize.xs;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                consts.appName,
                style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
              ),
              actions: _buildAppBarActions(context),
            ),
            body: isMobile //
                ? _getPage()
                : _buildDesktopView(),
            bottomNavigationBar: isMobile //
                ? _getNavigationBar()
                : null,
            floatingActionButton: _getFab(context, _currentPage, isMobile),
          );
        },
      ),
    );
  }

  Widget _buildDesktopView() {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: _currentPage,
          onDestinationSelected: _changePage,
          labelType: NavigationRailLabelType.none,
          minWidth: 56,
          leading: const ComposeFloatingActionButton(small: true),
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
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    final l10n = context.getL10n();

    return [
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () => context.push("/settings"),
        tooltip: l10n.settings,
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

  BottomNavigationBar? _getNavigationBar() {
    if (_tabs!.length < 2) {
      return null;
    }

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

class ComposeFloatingActionButton extends StatelessWidget {
  final bool small;

  const ComposeFloatingActionButton({
    Key? key,
    required this.small,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (small) {
      return FloatingActionButton.small(
        onPressed: () => context.showPostDialog(),
        elevation: 4.0,
        child: const Icon(Icons.edit_rounded),
      );
    } else {
      return FloatingActionButton(
        onPressed: () => context.showPostDialog(),
        elevation: 4.0,
        child: const Icon(Icons.edit_rounded),
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
