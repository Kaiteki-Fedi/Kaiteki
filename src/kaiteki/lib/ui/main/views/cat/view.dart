import "package:flutter/material.dart";
import "package:kaiteki/ui/main/views/cat/calendar.dart";
import "package:kaiteki/ui/main/views/view.dart";

class CatMainScreenView extends StatefulWidget implements MainScreenView {
  final Widget Function(TabKind tab) getPage;
  final TabKind tab;
  final Function(TabKind tab) onChangeTab;
  final Function(MainScreenViewType view) onChangeView;

  const CatMainScreenView({
    super.key,
    required this.getPage,
    required this.onChangeTab,
    required this.tab,
    required this.onChangeView,
  });

  @override
  State<CatMainScreenView> createState() => _CatMainScreenViewState();
}

class _CatMainScreenViewState extends State<CatMainScreenView> {
  @override
  Widget build(BuildContext context) {
    final showSidebar = MediaQuery.of(context).size.width > 1090;
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildDrawer(context),
          const VerticalDivider(),
          Expanded(
            child: widget.getPage(widget.tab),
          ),
          if (showSidebar) ...[
            const VerticalDivider(),
            const SizedBox(
              width: 332,
              child: Column(
                children: [
                  CatCalendarWidget(),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    // final expandDrawer = MediaQuery.of(context).size.width >= 1280;

    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 82,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  "https://s3.arkjp.net/misskey/65b25d3c-2ae4-474f-b1c0-050c8c8962e1.jpg",
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.25),
                ),
              ],
            ),
          ),
          Expanded(
            child: Theme(
              data: theme.copyWith(
                navigationDrawerTheme: theme.navigationDrawerTheme.copyWith(
                  tileHeight: 40,
                ),
                dividerTheme: theme.dividerTheme.copyWith(
                  space: (16 * 2) + 1,
                  indent: 16,
                  endIndent: 16,
                ),
              ),
              child: const NavigationDrawer(
                elevation: 0,
                children: [
                  NavigationDrawerDestination(
                    icon: Icon(Icons.home_outlined),
                    label: Text("Timeline"),
                  ),
                  NavigationDrawerDestination(
                    icon: Icon(Icons.notifications_outlined),
                    label: Text("Notifications"),
                  ),
                  Divider(),
                  NavigationDrawerDestination(
                    icon: Icon(Icons.search_rounded),
                    label: Text("Search"),
                  ),
                  Divider(),
                  NavigationDrawerDestination(
                    icon: Icon(Icons.devices_outlined),
                    label: Text("Switch UI"),
                  ),
                  NavigationDrawerDestination(
                    icon: Icon(Icons.settings_outlined),
                    label: Text("Settings"),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton.icon(
              icon: const Icon(Icons.edit_rounded),
              label: const Text("New post"),
              onPressed: () {},
              style: const ButtonStyle(
                alignment: Alignment.centerLeft,
                visualDensity: VisualDensity.comfortable,
                padding: MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
