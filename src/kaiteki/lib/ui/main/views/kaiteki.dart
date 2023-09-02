import "package:animations/animations.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/services/notifications.dart";
import "package:kaiteki/fediverse/services/timeline.dart";
import "package:kaiteki/platform_checks.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";
import "package:kaiteki/ui/main/drawer.dart";
import "package:kaiteki/ui/main/fab_data.dart";
import "package:kaiteki/ui/main/main_screen.dart";
import "package:kaiteki/ui/main/navigation/navigation_bar.dart";
import "package:kaiteki/ui/main/navigation/navigation_rail.dart";
import "package:kaiteki/ui/main/pages/notifications.dart";
import "package:kaiteki/ui/main/pages/timeline.dart";
import "package:kaiteki/ui/main/tab.dart";
import "package:kaiteki/ui/main/views/view.dart";
import "package:kaiteki/ui/pride.dart";
import "package:kaiteki/ui/shared/account_switcher_widget.dart";
import "package:kaiteki/ui/shared/side_sheet_manager.dart";
import "package:kaiteki/ui/shared/timeline/source.dart";
import "package:kaiteki/ui/window_class.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";
import "package:kaiteki_core/utils.dart";

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

    return SideSheetManager(
      builder: (sideSheet) => Scaffold(
        backgroundColor: isCompact ? null : getOutsideColor(context),
        appBar: buildAppBar(context, !isCompact),
        endDrawer: sideSheet,
        endDrawerEnableOpenDragGesture: false,
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
          child: child,
        );
      },
      child: Material(child: widget.getPage(widget.tab)),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    final l10n = context.l10n;

    return [
      IconButton(
        icon: const Icon(Icons.search_rounded),
        onPressed: getSearchCallback(context, ref),
        tooltip: l10n.searchButtonLabel,
      ),
      if (ref.watch(experimentsProvider(AppExperiment.notificationMenu)))
        MenuAnchor(
          menuChildren: const [
            SizedBox(
              width: 400,
              height: 600,
              child: NotificationsPage(),
            ),
          ],
          builder: (context, controller, child) {
            return IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: controller.open,
              tooltip: "Notifications",
            );
          },
        ),
      IconButton(
        icon: const Icon(Icons.refresh_rounded),
        onPressed: onRefresh,
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
          if (ref.watch(AppExperiment.timelineViews.provider))
            SubmenuButton(
              menuChildren: [
                for (final view in MainScreenViewType.values)
                  MenuItemButton(
                    onPressed: !(view == MainScreenViewType.videos &&
                            !supportsVideoPlayer)
                        ? () => widget.onChangeView(view)
                        : null,
                    trailingIcon: view == widget.type
                        ? const Icon(Icons.check_rounded)
                        : const SizedBox.square(dimension: 24),
                    leadingIcon: view.getIcon(),
                    child: Text(view.getDisplayName(l10n)),
                  ),
              ],
              child: const Text("View"),
            ),
          MenuItemButton(
            onPressed: () => showKeyboardShortcuts(context),
            child: Text(l10n.keyboardShortcuts),
          ),
        ],
      ),
      const AccountSwitcherWidget(size: 40),
    ];
  }

  Future<void> onRefresh() async {
    final accountKey = ref.read(currentAccountProvider)!.key;
    switch (widget.tab) {
      case TabKind.notifications:
        final notifier =
            ref.read(notificationServiceProvider(accountKey).notifier);
        await notifier.refresh();
        break;

      case TabKind.home:
        final timeline = ref.read(currentTimelineProvider);
        final notifier = ref.read(
          timelineServiceProvider(
            accountKey,
            StandardTimelineSource(timeline),
          ).notifier,
        );
        await notifier.refresh();
        break;

      case TabKind.chats:
      case TabKind.bookmarks:
      case TabKind.explore:
      case TabKind.directMessages:
        break;
    }
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
            backgroundColor: getOutsideColor(context) ?? Colors.transparent,
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

  PreferredSizeWidget buildAppBar(BuildContext context, bool immerse) {
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

    Color? backgroundColor, foregroundColor;

    if (immerse) {
      backgroundColor = getOutsideColor(context);
      if (backgroundColor != null) {
        foregroundColor = ThemeData.estimateBrightnessForColor(backgroundColor)
            .inverted
            .getColor();
      }
    }

    final theme = Theme.of(context);
    const shadows = [
      Shadow(color: Colors.white, blurRadius: 1),
      Shadow(color: Colors.white, blurRadius: 2),
      Shadow(color: Colors.white, blurRadius: 4),
    ];
    final prideEnabled = ref.watch(enablePrideFlag).value;
    final prideFlagDesign = ref.watch(prideFlag).value;
    return PreferredSizeStack(
      bottom: prideEnabled
          ? CustomPaint(painter: PridePainter(prideFlagDesign))
          : null,
      primary: AppBar(
        foregroundColor: prideEnabled ? Colors.black : foregroundColor,
        forceMaterialTransparency: theme.useMaterial3,
        title: Text(
          kAppName,
          style: (theme.ktkTextTheme?.kaitekiTextStyle ??
                  DefaultKaitekiTextTheme(context).kaitekiTextStyle)
              .copyWith(
            shadows: prideEnabled ? shadows : null,
          ),
        ),
        iconTheme: prideEnabled ? const IconThemeData(shadows: shadows) : null,
        actions: _buildAppBarActions(context),
        scrolledUnderElevation: immerse ? 0.0 : 4.0,
      ),
    );
  }
}

class PreferredSizeStack extends StatelessWidget
    implements PreferredSizeWidget {
  final PreferredSizeWidget primary;
  final Widget? bottom;

  const PreferredSizeStack({
    super.key,
    required this.primary,
    required this.bottom,
  });

  @override
  Size get preferredSize => primary.preferredSize;

  @override
  Widget build(BuildContext context) {
    final bottom = this.bottom;
    return Stack(
      children: [
        if (bottom != null) Positioned.fill(child: bottom),
        primary,
      ],
    );
  }
}
