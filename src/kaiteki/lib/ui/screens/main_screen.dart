import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/ui/forms/post_form.dart';
import 'package:kaiteki/ui/pages/timeline_page.dart';
import 'package:kaiteki/ui/screens/settings/settings_screen.dart';
import 'package:kaiteki/ui/widgets/account_switcher_widget.dart';
import 'package:kaiteki/ui/widgets/icon_landing_widget.dart';
import 'package:mdi/mdi.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final List<_MainScreenTab> _tabs;
  final _pageController = PageController();
  var _currentPage = 0;
  var pageViewKey = UniqueKey();

  @override
  void initState() {
    super.initState();

    _tabs = [
      _MainScreenTab(
        icon: Mdi.home,
        text: 'Timeline',
        fab: _FloatingActionButtonData(
          icon: Mdi.pencil,
          tooltip: 'Compose a new status',
          text: 'Compose',
          onTap: () => onComposeStatus(context, null),
        ),
      ),
      const _MainScreenTab(
        icon: Mdi.bell,
        text: "Notifications",
        //fabTooltip: "Mark all as read",
        //fabText: "Read",
        //fabIcon: Mdi.checkAll,
        //fabOnTap: () {},
      ),
      const _MainScreenTab(
        icon: Mdi.forum,
        text: "Chats",
        //fabTooltip: 'New chat',
        //fabIcon: Mdi.plus,
        //fabText: "New",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var appName = "Kaiteki";

    return LayoutBuilder(
      builder: (_, constraints) {
        var desktopMode = Constants.desktopThreshold <= constraints.maxWidth;
        if (desktopMode) {
          return buildDesktopView(appName);
        } else {
          return buildMobileView(appName);
        }
      },
    );
  }

  Widget buildDesktopView(String appName) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            appName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: const [AccountSwitcherWidget(size: 40)],
        ),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _currentPage,
              onDestinationSelected: (x) => changePage(x),
              destinations: [
                for (var tab in _tabs)
                  NavigationRailDestination(
                    icon: Icon(tab.icon),
                    label: Text(tab.text),
                  ),
                const NavigationRailDestination(
                  icon: Icon(Mdi.cog),
                  label: Text("Settings"),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: getPageView()),
          ],
        ),
        floatingActionButton: getFabDesktop(context, _currentPage));
  }

  Widget buildMobileView(String appName) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SettingsScreen()),
            ),
          ),
          const AccountSwitcherWidget(size: 40),
        ],
      ),
      body: getPageView(),
      bottomNavigationBar: getNavigationBar(),
      floatingActionButton: getFab(context, _currentPage),
    );
  }

  Iterable<Widget> getTabListItems() {
    var i = 0;

    return _tabs.map((tab) {
      var x = i;

      i++;

      return ListTile(
        leading: Icon(tab.icon),
        title: Text(tab.text),
        selected: _currentPage == x,
        onTap: () => changePage(x),
      );
    });
  }

  getPageView() {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      key: pageViewKey,
      children: const [
        TimelinePage(key: ValueKey(0)),
        Center(
          child: IconLandingWidget(
            Mdi.dotsHorizontal,
            "Not implemented yet...",
          ),
        ),
        Center(
          child: IconLandingWidget(
            Mdi.dotsHorizontal,
            "Not implemented yet...",
          ),
        ),
      ],
    );
  }

  getNavigationBar() {
    if (_tabs.length < 2) return null;

    return BottomNavigationBar(
      elevation: 8,
      onTap: changePage,
      currentIndex: _currentPage,
      items: [
        for (var tab in _tabs)
          BottomNavigationBarItem(
            icon: Icon(tab.icon),
            label: tab.text,
          ),
      ],
    );
  }

  void changePage(int index) {
    var isOutsideOfTabs = _tabs.length <= index;
    if (isOutsideOfTabs) {
      var diff = _tabs.length - index;
      switch (diff) {
        case 0:
          Navigator.of(context).pushNamed('/settings');
          return;
      }
    }

    setState(() {
      _currentPage = index;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
      );
    });
  }

  FloatingActionButton? getFab(BuildContext context, int index) {
    var tab = _tabs[_currentPage];

    if (tab.fab == null) return null;

    return FloatingActionButton(
      tooltip: tab.fab!.tooltip,
      child: Icon(tab.fab!.icon),
      onPressed: tab.fab!.onTap,
    );
  }

  FloatingActionButton? getFabDesktop(BuildContext context, int index) {
    var tab = _tabs[_currentPage];

    if (tab.fab == null) return null;

    return FloatingActionButton.extended(
      label: Text(tab.fab!.text),
      icon: Icon(tab.fab!.icon),
      onPressed: tab.fab!.onTap,
    );
  }

  void onComposeStatus(BuildContext context, Post? replyTo) async {
    await showDialog(
      context: context,
      builder: (_) => Dialog(
        child: SizedBox(
          child: Scaffold(body: PostForm(replyTo: replyTo)),
          width: 800,
          height: 500,
        ),
      ),
      barrierDismissible: true,
    );
    // Navigator.push(context, MaterialPageRoute(builder: (_) => PostScreen()));
  }
}

class _MainScreenTab {
  final String text;
  final IconData icon;
  final _FloatingActionButtonData? fab;

  const _MainScreenTab({
    required this.icon,
    required this.text,
    this.fab,
  });
}

class _FloatingActionButtonData {
  final void Function() onTap;
  final String tooltip;
  final String text;
  final IconData icon;

  _FloatingActionButtonData({
    required this.onTap,
    required this.tooltip,
    required this.text,
    required this.icon,
  });
}
