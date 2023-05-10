import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/main/views/view.dart";
import "package:kaiteki/ui/shared/account_list/instance_icon.dart";
import "package:kaiteki/ui/shared/account_switcher_widget.dart";
import "package:kaiteki/ui/window_class.dart";
import "package:kaiteki/utils/extensions.dart";

class BirdMainScreenView extends ConsumerStatefulWidget
    implements MainScreenView {
  final Widget Function(TabKind tab) getPage;
  final TabKind tab;
  final Function(TabKind tab) onChangeTab;
  final Function(MainScreenViewType view) onChangeView;

  const BirdMainScreenView({
    super.key,
    required this.getPage,
    required this.onChangeTab,
    required this.tab,
    required this.onChangeView,
  });

  @override
  ConsumerState<BirdMainScreenView> createState() => _BirdMainScreenViewState();
}

class _BirdMainScreenViewState extends ConsumerState<BirdMainScreenView> {
  @override
  Widget build(BuildContext context) {
    if (WindowClass.fromContext(context) <= WindowClass.compact) {
      return buildCompact(context);
    }

    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 350 - 275),
          SizedBox(
            width: 275,
            child: NavigationDrawer(
              elevation: 0,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28.0,
                    vertical: 16.0,
                  ),
                  child: Row(
                    children: [
                      InstanceIcon(
                        ref.watch(accountProvider)!.key.host,
                      ),
                    ],
                  ),
                ),
                const NavigationDrawerDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text("Home"),
                ),
                const NavigationDrawerDestination(
                  icon: Icon(Icons.notifications_outlined),
                  selectedIcon: Icon(Icons.notifications),
                  label: Text("Notifications"),
                ),
                const NavigationDrawerDestination(
                  icon: Icon(Icons.email_outlined),
                  selectedIcon: Icon(Icons.email_rounded),
                  label: Text("Messages"),
                ),
                const NavigationDrawerDestination(
                  icon: Icon(Icons.article_outlined),
                  selectedIcon: Icon(Icons.article),
                  label: Text("Lists"),
                ),
                const NavigationDrawerDestination(
                  icon: Icon(Icons.bookmark_outline),
                  selectedIcon: Icon(Icons.bookmark),
                  label: Text("Bookmarks"),
                ),
                const NavigationDrawerDestination(
                  icon: Icon(Icons.verified_outlined),
                  label: Text("Pleroma Gold"),
                ),
                const NavigationDrawerDestination(
                  icon: Icon(Icons.person_outlined),
                  selectedIcon: Icon(Icons.person),
                  label: Text("Profile"),
                ),
                NavigationDrawerDestination(
                  icon: Icon(Icons.adaptive.more_rounded),
                  label: const Text("More"),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FilledButton(
                    onPressed: () => context.pushNamed(
                      "compose",
                      pathParameters: ref.accountRouterParams,
                    ),
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.comfortable,
                      minimumSize: const Size(100, 52),
                    ),
                    child: const Text("Compose"),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(),
          SizedBox(
            width: 600,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 53,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Text(
                        "Home",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                ),
                Expanded(child: widget.getPage(widget.tab)),
              ],
            ),
          ),
          const VerticalDivider(),
          const SizedBox(
            width: 350,
          ),
        ],
      ),
    );
  }

  Widget buildCompact(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          NavigationBar(
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            indicatorColor: Colors.transparent,
            elevation: 0,
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            height: 52,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: "Home",
              ),
              NavigationDestination(
                icon: Icon(Icons.search),
                label: "Search",
              ),
              NavigationDestination(
                icon: Icon(Icons.notifications_outlined),
                selectedIcon: Icon(Icons.notifications),
                label: "Notifications",
              ),
              NavigationDestination(
                icon: Icon(Icons.email_outlined),
                selectedIcon: Icon(Icons.email),
                label: "Messages",
              ),
            ],
          ),
        ],
      ),
      body: widget.getPage(widget.tab),
      appBar: AppBar(
        centerTitle: true,
        title: InstanceIcon(
          ref.watch(accountProvider)!.key.host,
        ),
        leading: const AccountSwitcherWidget(),
      ),
    );
  }
}
