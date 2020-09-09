import 'package:flutter/material.dart';
import 'package:kaiteki/api/clients/misskey_client.dart';
import 'package:kaiteki/app_preferences.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/ui/forms/post_form.dart';
import 'package:kaiteki/ui/pages/chats_page.dart';
import 'package:kaiteki/ui/pages/deck_page.dart';
import 'package:kaiteki/ui/pages/notifications_page.dart';
import 'package:kaiteki/ui/pages/timeline_page.dart';
import 'package:kaiteki/ui/screens/misskey_page_screen.dart';
import 'package:kaiteki/ui/screens/settings_screen.dart';
import 'package:kaiteki/ui/widgets/account_switcher_widget.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<_MainScreenTab> _tabs = <_MainScreenTab>[
    _MainScreenTab(Mdi.home, "Timeline"),
    _MainScreenTab(Mdi.bell, "Notifications"),
    _MainScreenTab(Mdi.forum, "Chats"),
    _MainScreenTab(Mdi.viewColumn, "Deck"),
  ];

  PageController _pageController = PageController();
  int _currentPage = 0;

  var pageViewKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    var preferences = Provider.of<AppPreferences>(context);

    return LayoutBuilder(
      builder: (_, constraints) {
        var desktopMode = Constants.desktopThreshold <= constraints.maxWidth;

        if (desktopMode) {
          return Scaffold(
            appBar: AppBar(
              leading: AccountSwitcherWidget(),
              title: Text(
                preferences.getPreferredAppName(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: Row(
              children: [
                if (desktopMode)
                  Drawer(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _tabs.length + 4,
                      itemBuilder: (_, int i) {
                        if (_tabs.length <= i) {
                          var fakeI = i - _tabs.length;
                          switch (fakeI) {
                            case 0: return Divider();
                            case 1: return ListTile(
                              onTap: () => Navigator.pushNamed(context, "/settings"),
                              leading: Icon(Mdi.cog),
                              title: Text("Settings"),
                            );
                            case 2: return ListTile(
                              onTap: () => debugAction(context),
                              leading: Icon(Mdi.bug),
                              title: Text("Debug Action"),
                            );
                            case 3: return SwitchListTile(
                              title: Text("At Work Mode"),
                              value: preferences.atWorkMode
                            );
                          }
                        }

                        var tab = _tabs[i];
                        return ListTile(
                          leading: Icon(tab.icon),
                          title: Text(tab.text),
                          selected: _currentPage == i,
                          onTap: () => changePage(i),
                        );
                      },
                    ),
                  ),

                Expanded(
                  child: getPageView(),
                ),
              ],
            ),
            floatingActionButton: getFloatingActionButtonDesktop(context, _currentPage)
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              leading: AccountSwitcherWidget(),
              title: Text(
                preferences.getPreferredAppName(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  icon: Icon(Mdi.bug),
                  onPressed: () => debugAction(context)
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen())),
                ),
              ],
            ),
            body: getPageView(),
            bottomNavigationBar: getNavigationBar(),
            floatingActionButton: getFloatingActionButton(context, _currentPage)
          );
        }
      },
    );
  }

  getPageView() => PageView(
    controller: _pageController,
    physics: NeverScrollableScrollPhysics(),
    key: pageViewKey,
    children: [
      TimelinePage(key: ValueKey(0)),
      NotificationsPage(key: ValueKey(1)),
      ChatsPage(key: ValueKey(2)),
      DeckPage(key: ValueKey(3))
    ],
  );

  getNavigationBar() => BottomNavigationBar(
    elevation: 8,
    type: BottomNavigationBarType.fixed,
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

  void changePage(int index) {
    setState(() {
      _currentPage = index;
      _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 150),
          curve: Curves.easeInOut
      );
    });
  }

  FloatingActionButton getFloatingActionButton(BuildContext context, int index) {
    switch (index) {
      case 0: return FloatingActionButton(
        tooltip: 'Compose a new status',
        child: Icon(Mdi.pencil),
        onPressed: () => onComposeStatus(context),
      );
      case 1: return FloatingActionButton(
        tooltip: 'Mark all as read',
        child: Icon(Mdi.checkAll),
        onPressed: null,
      );
      case 2: return FloatingActionButton(
        tooltip: 'New chat',
        child: Icon(Icons.add),
        onPressed: null,
      );
    }
    return null;
  }
  FloatingActionButton getFloatingActionButtonDesktop(BuildContext context, int index) {
    switch (index) {
      case 0: return FloatingActionButton.extended(
        tooltip: 'Compose a new status',
        label: Text("Compose"),
        icon: Icon(Mdi.pencil),
        onPressed: () => onComposeStatus(context),
      );
      case 1: return FloatingActionButton.extended(
        tooltip: 'Mark all as read',
        label: Text('Read'),
        icon: Icon(Mdi.checkAll),
        onPressed: null,
      );
      case 2: return FloatingActionButton.extended(
        tooltip: 'New chat',
        label: Text('New chat'),
        icon: Icon(Icons.add),
        onPressed: null,
      );
    }
    return null;
  }

  void debugAction(BuildContext context) async {
    var client = MisskeyClient();
    client.instance = "misskey.io";
    var page = await client.getPage(
      "sWwuYT3qpmh3g9EW",
      "Craftplacer",
      "1597983613670",
    );

    Navigator.push(context, MaterialPageRoute(builder: (_) => MisskeyPageScreen(page)));
  }

  void onComposeStatus(BuildContext context) async {
    await showDialog(
      context: context,

      child: Dialog(

        child: Container(
          child: PostForm(),
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

  const _MainScreenTab(this.icon, this.text);
}