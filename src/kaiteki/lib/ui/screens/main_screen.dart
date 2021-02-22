import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/model/fediverse/post.dart';
import 'package:kaiteki/ui/forms/post_form.dart';
import 'package:kaiteki/ui/pages/timeline_page.dart';
import 'package:kaiteki/ui/screens/settings/settings_screen.dart';
import 'package:kaiteki/ui/widgets/account_switcher_widget.dart';
import 'package:mdi/mdi.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<_MainScreenTab> _tabs;
  var _pageController = PageController();
  var _currentPage = 0;
  var pageViewKey = UniqueKey();

  @override
  void initState() {
    super.initState();

    _tabs = [
      _MainScreenTab(
        icon: Mdi.home,
        text: "Timeline",
        fabTooltip: "Compose a new status",
        fabText: "Compose",
        fabIcon: Mdi.pencil,
        fabOnTap: () => onComposeStatus(context, null),
      ),
      // _MainScreenTab(
      //   icon: Mdi.bell,
      //   text: "Notifications",
      //   fabTooltip: "Mark all as read",
      //   fabText: "Read",
      //   fabIcon: Mdi.checkAll,
      //   fabOnTap: () {},
      // ),
      // _MainScreenTab(
      //   icon: Mdi.forum,
      //   text: "Chats",
      //   fabTooltip: 'New chat',
      //   fabIcon: Mdi.plus,
      //   fabText: "New",
      // ),
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
          leading: AccountSwitcherWidget(),
          title: Text(
            appName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Row(
          children: [
            Drawer(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: getTabListItems().toList(),
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () => Navigator.pushNamed(context, "/settings"),
                    leading: Icon(Mdi.cog),
                    title: Text("Settings"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: getPageView(),
            ),
          ],
        ),
        floatingActionButton: getFabDesktop(context, _currentPage));
  }

  Widget buildMobileView(String appName) {
    return Scaffold(
      appBar: AppBar(
        leading: AccountSwitcherWidget(),
        title: Text(appName, style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SettingsScreen()),
            ),
          ),
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
      physics: NeverScrollableScrollPhysics(),
      key: pageViewKey,
      children: [TimelinePage(key: ValueKey(0))],
    );
  }

  getNavigationBar() {
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
    setState(() {
      _currentPage = index;
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 150),
        curve: Curves.easeInOut,
      );
    });
  }

  FloatingActionButton getFab(BuildContext context, int index) {
    var tab = _tabs[_currentPage];

    if (tab.fabIcon == null) return null;

    return FloatingActionButton(
      tooltip: tab.fabTooltip,
      child: Icon(tab.fabIcon),
      onPressed: tab.fabOnTap,
    );
  }

  FloatingActionButton getFabDesktop(BuildContext context, int index) {
    var tab = _tabs[_currentPage];

    if (tab.fabIcon == null) return null;

    return FloatingActionButton.extended(
      label: Text(tab.fabText),
      icon: Icon(tab.fabIcon),
      onPressed: tab.fabOnTap,
    );
  }

  void onComposeStatus(BuildContext context, Post replyTo) async {
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

  final void Function() fabOnTap;
  final String fabTooltip;
  final String fabText;
  final IconData fabIcon;

  const _MainScreenTab({
    this.icon,
    this.text,
    this.fabOnTap,
    this.fabTooltip,
    this.fabText,
    this.fabIcon,
  });
}
