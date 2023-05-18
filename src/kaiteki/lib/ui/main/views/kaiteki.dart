import "package:animations/animations.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/interfaces/bookmark_support.dart";
import "package:kaiteki/fediverse/interfaces/chat_support.dart";
import "package:kaiteki/fediverse/interfaces/explore_support.dart";
import "package:kaiteki/fediverse/interfaces/notification_support.dart";
import "package:kaiteki/fediverse/services/notifications.dart";
import "package:kaiteki/platform_checks.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";
import "package:kaiteki/ui/main/drawer.dart";
import "package:kaiteki/ui/main/fab_data.dart";
import "package:kaiteki/ui/main/main_screen.dart";
import "package:kaiteki/ui/main/navigation/navigation_bar.dart";
import "package:kaiteki/ui/main/navigation/navigation_rail.dart";
import "package:kaiteki/ui/main/tab.dart";
import "package:kaiteki/ui/main/views/view.dart";
import "package:kaiteki/ui/shared/account_switcher_widget.dart";
import "package:kaiteki/ui/window_class.dart";
import "package:kaiteki/utils/extensions.dart";

class KaitekiMainScreenView extends ConsumerStatefulWidget
    implements MainScreenView {
  final Widget Function(TabKind tab) getPage;
  final TabKind tab;
  final Function(TabKind tab) onChangeTab;
  final Function([MainScreenViewType? view]) onChangeView;

  const KaitekiMainScreenView({
    super.key,
    required this.getPage,
    required this.onChangeTab,
    required this.tab,
    required this.onChangeView,
  });

  @override
  ConsumerState<KaitekiMainScreenView> createState() =>
      _KaitekiMainScreenViewState();
}

class _KaitekiMainScreenViewState extends ConsumerState<KaitekiMainScreenView> {
  late List<TabKind> _tabs;

  Color? getOutsideColor(BuildContext context) {
    final theme = Theme.of(context);
    if (theme.useMaterial3) return theme.colorScheme.surfaceVariant;
    return null;
  }

  List<TabKind> getTabs() {
    final adapter = ref.watch(adapterProvider);

    final supportsNotifications = adapter is NotificationSupport;
    final supportsChats =
        adapter.safeCast<ChatSupport>()?.capabilities.supportsChat ?? false;
    final supportsBookmarks = adapter is BookmarkSupport;
    final supportsExplore = adapter is ExploreSupport;

    final chatsEnabled = ref.watch(AppExperiment.chats.provider);

    return [
      TabKind.home,
      if (supportsNotifications) TabKind.notifications,
      if (supportsChats && chatsEnabled) TabKind.chats,
      if (supportsBookmarks) TabKind.bookmarks,
      if (supportsExplore) TabKind.explore,
    ];
  }

  @override
  Widget build(BuildContext context) {
    _tabs = getTabs();

    final windowClass = WindowClass.fromContext(context);
    final isCompact = windowClass <= WindowClass.compact;

    final body = buildBody(context);
    final tabItems = _tabs.map((e) => buildTabItem(context, e)).toList();
    final tabItem = tabItems.firstWhereOrNull((e) => e.kind == widget.tab);

    return Scaffold(
      backgroundColor: isCompact ? null : getOutsideColor(context),
      appBar: buildAppBar(context),
      body: isCompact
          ? body
          : _buildDesktopView(
              context,
              windowClass,
              body,
              tabItems,
            ),
      bottomNavigationBar: isCompact
          ? MainScreenNavigationBar(
              tabs: tabItems,
              currentIndex: _tabs.indexOf(widget.tab),
              onChangeIndex: (i) => widget.onChangeTab(_tabs[i]),
            )
          : null,
      floatingActionButton:
          (!isCompact && (tabItem?.hideFabWhenDesktop ?? false))
              ? null
              : tabItem?.fab.nullTransform<Widget?>(
                  (data) => buildFloatingActionButton(
                    context,
                    data,
                    windowClass >= WindowClass.expanded,
                  ),
                ),
      drawer: MainScreenDrawer(
        onSwitchLayout: () => widget.onChangeView(),
      ),
    );
  }

  MainScreenTab buildTabItem(BuildContext context, TabKind kind) {
    final l10n = context.l10n;

    return switch (kind) {
      TabKind.home => MainScreenTab(
          TabKind.home,
          fab: FloatingActionButtonData(
            icon: Icons.edit_rounded,
            tooltip: l10n.composeDialogTitle,
            text: l10n.composeButtonLabel,
            onTap: () => context.pushNamed(
              "compose",
              pathParameters: ref.accountRouterParams,
            ),
          ),
          hideFabWhenDesktop: true,
        ),
      TabKind.notifications => MainScreenTab(
          TabKind.notifications,
          fetchUnreadCount: () =>
              ref.watch(notificationCountProvider).valueOrNull,
        ),
      _ => MainScreenTab(kind),
    };
  }

  Widget? buildFloatingActionButton(
    BuildContext context,
    FloatingActionButtonData data,
    bool extended,
  ) {
    if (extended) {
      return FloatingActionButton.extended(
        label: Text(data.text),
        icon: Icon(data.icon),
        onPressed: data.onTap,
      );
    }

    return FloatingActionButton(
      tooltip: data.tooltip,
      onPressed: data.onTap,
      child: Icon(data.icon),
    );
  }

  Widget buildBody(BuildContext context) {
    return PageTransitionSwitcher(
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
        return FadeThroughTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          child: Material(child: child),
        );
      },
      child: widget.getPage(widget.tab),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    final l10n = context.l10n;

    return [
      if (widget.tab == TabKind.home &&
          ref.watch(AppExperiment.timelineViews.provider))
        MenuAnchor(
          builder: (context, controller, child) {
            return IconButton(
              icon: widget.type.getIcon(),
              tooltip: "View",
              onPressed: controller.open,
            );
          },
          menuChildren: [
            for (final view in MainScreenViewType.values)
              MenuItemButton(
                onPressed:
                    !(view == MainScreenViewType.videos && !supportsVideoPlayer)
                        ? () => widget.onChangeView(view)
                        : null,
                trailingIcon: view == widget.type
                    ? const Icon(Icons.check_rounded)
                    : const SizedBox.square(dimension: 24),
                leadingIcon: view.getIcon(),
                child: Text(view.getDisplayName(l10n)),
              ),
          ],
        ),
      IconButton(
        icon: const Icon(Icons.search_rounded),
        onPressed: getSearchCallback(context, ref),
        tooltip: l10n.searchButtonLabel,
      ),
      IconButton(
        icon: const Icon(Icons.refresh_rounded),
        onPressed: switch (widget.tab) {
          TabKind.notifications => () async {
              await ref
                  .read(
                    notificationServiceProvider(
                      ref.read(accountProvider)!.key,
                    ).notifier,
                  )
                  .refresh();
            },
          _ => null,
        },
        tooltip: l10n.refreshTimelineButtonLabel,
      ),

      // TODO(Craftplacer): hide if no keyboard is detected
      MenuAnchor(
        builder: (context, controller, child) {
          return IconButton(
            icon: Icon(Icons.adaptive.more_rounded),
            tooltip: context.materialL10n.moreButtonTooltip,
            onPressed: controller.open,
          );
        },
        menuChildren: [
          MenuItemButton(
            onPressed: () => showKeyboardShortcuts(context),
            child: Text(l10n.keyboardShortcuts),
          ),
        ],
      ),
      const AccountSwitcherWidget(size: 40),
    ];
  }

  Widget _buildDesktopView(
    BuildContext context,
    WindowClass windowClass,
    Widget child,
    List<MainScreenTab> tabItems,
  ) {
    final m3 = Theme.of(context).useMaterial3;
    return Row(
      children: [
        if (_tabs.length >= 2) ...[
          MainScreenNavigationRail(
            tabs: tabItems,
            currentIndex: _tabs.indexOf(widget.tab),
            onChangeIndex: (i) => widget.onChangeTab(_tabs[i]),
            extended: windowClass >= WindowClass.expanded,
            backgroundColor: getOutsideColor(context),
          ),
          if (!m3) const VerticalDivider(thickness: 1, width: 1),
        ],
        Expanded(
          child: Theme.of(context).useMaterial3
              ? ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                  ),
                  child: child,
                )
              : child,
        ),
      ],
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    if (ref.watch(useSearchBar).value) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(56.0 + 8.0 * 2),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              focusNode: FocusNode(canRequestFocus: false, skipTraversal: true),
              onTap: () => context.pushNamed(
                "search",
                pathParameters: ref.accountRouterParams,
              ),
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              leading: const DrawerButton(),
              hintText: "Search",
              trailing: const [
                AccountSwitcherWidget(size: 30),
              ],
            ),
          ),
        ),
      );
    }

    Color? foregroundColor;

    final outsideColor = getOutsideColor(context);
    if (outsideColor != null) {
      foregroundColor = ThemeData.estimateBrightnessForColor(outsideColor)
          .inverted
          .getColor();
    }

    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: outsideColor,
      foregroundColor: foregroundColor,
      title: Text(
        appName,
        style: theme.ktkTextTheme?.kaitekiTextStyle,
      ),
      actions: _buildAppBarActions(context),
      elevation: 0.0,
      scrolledUnderElevation: outsideColor != null ? 0.0 : 4.0,
    );
  }
}
