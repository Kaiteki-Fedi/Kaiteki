import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/main/views/view.dart";
import "package:kaiteki/ui/shared/account_list/instance_icon.dart";
import "package:kaiteki/ui/shared/account_switcher_widget.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/ui/window_class.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";
import "package:kaiteki_core/utils.dart";

class BirdMainScreenView extends ConsumerStatefulWidget
    implements MainScreenView {
  final Widget Function(TabKind tab) getPage;
  final TabKind tab;
  final Function(TabKind tab) onChangeTab;
  final Function([MainScreenViewType? view]) onChangeView;

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
    final footerButtons = [
      (text: "About Kaiteki", onPressed: () => context.pushNamed("/about")),
    ];

    if (WindowClass.fromContext(context) <= WindowClass.compact) {
      return buildCompact(context);
    }

    final explore = ref.watch(adapterProvider).safeCast<ExploreSupport>();
    final account = ref.watch(currentAccountProvider);

    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 350 - 275),
          SizedBox(
            width: 275,
            child: Column(
              children: [
                Expanded(
                  child: NavigationDrawer(
                    elevation: 0,
                    onDestinationSelected: _onDrawerDestinationSelected,
                    selectedIndex: switch (widget.tab) {
                      TabKind.home => 0,
                      TabKind.bookmarks => 4,
                      TabKind.notifications => 1,
                      TabKind.directMessages => 2,
                      _ => null,
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28.0,
                          vertical: 16.0,
                        ),
                        child: Row(
                          children: [
                            InstanceIcon(
                              ref.watch(currentAccountProvider)!.key.host,
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
                      // const NavigationDrawerDestination(
                      //   icon: Icon(Icons.verified_outlined),
                      //   label: Text("Pleroma Gold"),
                      // ),
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
                if (account != null)
                  ListTile(
                    leading: AvatarWidget(account.user),
                    title: Text.rich(
                      account.user.renderDisplayName(context, ref),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                    subtitle: Text(
                      account.user.handle.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                    onTap: () => context.pushNamed("accounts"),
                  )
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
                        switch (widget.tab) {
                          TabKind.home => "Home",
                          _ => widget.tab.getLabel(context),
                        },
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
          SizedBox(
            width: 350,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (explore != null) ...[
                      Card(
                        child: FutureBuilder(
                          future: explore.getTrendingHashtags(),
                          builder: (context, snapshot) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "Trends",
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                                if (snapshot.hasData)
                                  for (final trend in snapshot.data!)
                                    ListTile(
                                      title: Text(trend),
                                      onTap: () => context.pushNamed(
                                        "search",
                                        pathParameters: {
                                          // "query": trend.name,
                                          ...ref.accountRouterParams,
                                        },
                                      ),
                                    )
                                else
                                  const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: centeredCircularProgressIndicator,
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    DefaultTextStyle.merge(
                      style: Theme.of(context).colorScheme.outline.textStyle,
                      child: Wrap(
                        children: [
                          for (final button in footerButtons)
                            Text.rich(
                              TextSpan(
                                text: button.text,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = button.onPressed,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
          ref.watch(currentAccountProvider)!.key.host,
        ),
        leading: const AccountSwitcherWidget(),
      ),
    );
  }

  void _onDrawerDestinationSelected(int value) {
    switch (value) {
      case 0:
        widget.onChangeTab(TabKind.home);
        break;
      case 1:
        widget.onChangeTab(TabKind.notifications);
        break;
      case 2:
        widget.onChangeTab(TabKind.directMessages);

        break;
      case 3:
        context.pushNamed(
          "lists",
          pathParameters: ref.accountRouterParams,
        );
        break;
      case 4:
        widget.onChangeTab(TabKind.bookmarks);
        break;
      case 5:
        context.showUser(ref.read(currentAccountProvider)!.user, ref);
        break;
      case 6:
        widget.onChangeView();
        break;
    }
  }
}
