import "dart:math";

import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/model/user/user.dart";
import "package:kaiteki/ui/shared/popup_menu_wrapper.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/ui/shared/timeline.dart";
import "package:kaiteki/ui/user/user_panel.dart";
import "package:kaiteki/ui/user/user_sliver.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:share_plus/share_plus.dart";

const avatarSizeCompact = 72.0;
const avatarSize = 96.0;
const bannerHeight = 8.0 * 24.0;

class UserScreen extends ConsumerStatefulWidget {
  final String id;

  const UserScreen({super.key, required this.id});

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen> {
  Future<User>? _future;

  late StateProvider<bool> _showReplies;

  @override
  void initState() {
    super.initState();
    _future = ref.read(adapterProvider).getUserById(widget.id);
    _showReplies = StateProvider((_) => true);
  }

  Widget _buildAppBarUserName(User user) {
    return ListTile(
      title: Text.rich(
        user.renderDisplayName(context, ref),
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
      subtitle: Text(
        user.handle.toString(),
        style: Theme.of(context).textTheme.labelSmall,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildBanner(User? user) {
    final placeholder = ColoredBox(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: const SizedBox.expand(),
    );

    if (user == null) return placeholder;

    final bannerUrl = user.bannerUrl;
    if (bannerUrl == null) return placeholder;

    return Image.network(
      bannerUrl,
      fit: BoxFit.cover,
      isAntiAlias: true,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 600;

    return DefaultTabController(
      length: 3,
      child: FutureBuilder<User>(
        future: _future,
        builder: (context, snapshot) {
          final user = snapshot.data;
          final includeReplies = ref.watch(_showReplies);

          if (isCompact) {
            return buildBodyCompact(context, user, includeReplies);
          }

          return buildBody(context, user, includeReplies);
        },
      ),
    );
  }

  Color get _backgroundColor {
    return ElevationOverlay.applySurfaceTint(
      Theme.of(context).colorScheme.surface,
      Theme.of(context).colorScheme.surfaceTint,
      2,
    );
  }

  Widget buildBody(BuildContext context, User? user, bool includeReplies) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton.filledTonal(
              onPressed: Navigator.of(context).maybePop,
              icon: Icon(Icons.adaptive.arrow_back),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            ),
          ),
          // https://m3.material.io/foundations/layout/canonical-layouts/supporting-pane#13c3c489-9cc7-4830-b44a-fe6c2d431c1f
          SizedBox(
            // HACK(Craftplacer): Material 3 advises to only show the supporting
            // pane when the screen hits the expanded layout class. Since the
            // recommended side pane width is 360dp, we use what is lower of
            // width and a third of the screen, so the content pane doesn't get
            //too squished.
            width: min(MediaQuery.of(context).size.width / 3, 360),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: avatarSize * 0.25),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16),
                          ),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: _buildBanner(user),
                          ),
                        ),
                      ),
                      if (user != null)
                        Positioned(
                          left: 16.0,
                          child: AvatarWidget(user, size: avatarSize),
                        ),
                    ],
                  ),
                  if (user != null) ...[
                    const SizedBox(height: 16),
                    UserPanel(user),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: ColoredBox(
                  color: Theme.of(context).colorScheme.surface,
                  child: Column(
                    children: [
                      Material(child: buildTabBar()),
                      const Divider(),
                      Expanded(
                        child: Material(child: buildTabBarView(includeReplies)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget buildBodyCompact(
    BuildContext context,
    User? user,
    bool includeReplies,
  ) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          IconButton adaptiveIconButton({
            required Widget icon,
            required VoidCallback onPressed,
            required String tooltip,
          }) {
            return innerBoxIsScrolled
                ? IconButton(
                    icon: icon,
                    onPressed: onPressed,
                    tooltip: tooltip,
                  )
                : IconButton.filledTonal(
                    icon: icon,
                    onPressed: onPressed,
                    tooltip: tooltip,
                  );
          }

          final moreButton = PopupMenuWrapper(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () async {
                  final url = user?.url;
                  if (url == null) return;
                  await Share.share(url.toString());
                },
                enabled: user?.url != null,
                child: const Text("Share"),
              ),
            ],
            builder: (context, onTap) {
              return adaptiveIconButton(
                icon: Icon(Icons.adaptive.more),
                onPressed: onTap,
                tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
              );
            },
          );
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              leading: adaptiveIconButton(
                icon: Icon(Icons.adaptive.arrow_back),
                onPressed: () => Navigator.of(context).maybePop(),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              ),
              backgroundColor: _backgroundColor,
              scrolledUnderElevation: 0,
              actions: [
                if (innerBoxIsScrolled)
                  moreButton
                else
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(24),
                      ),
                    ),
                    child: moreButton,
                  ),
              ],
              title: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: !innerBoxIsScrolled
                    ? null
                    : user.nullTransform(_buildAppBarUserName),
              ),
              pinned: true,
              forceElevated: innerBoxIsScrolled,
              expandedHeight: bannerHeight + (avatarSizeCompact / 2),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Padding(
                      padding: !innerBoxIsScrolled
                          ? const EdgeInsets.only(
                              bottom: avatarSizeCompact / 2,
                            )
                          : EdgeInsets.zero,
                      child: _buildBanner(user),
                    ),
                    if (user != null && !innerBoxIsScrolled)
                      Positioned(
                        left: 16.0,
                        bottom: 0,
                        child: AvatarWidget(user, size: avatarSizeCompact),
                      )
                  ],
                ),
              ),
            ),
            if (user != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: UserPanel(user),
                ),
              ),
            CustomSliverPersistentHeader(
              child: Material(
                color: _backgroundColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildTabBar(),
                    const Divider(),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Material(
          child: buildTabBarView(includeReplies),
        ),
      ),
    );
  }

  Widget buildTabBarView(bool includeReplies) {
    return TabBarView(
      children: [
        CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    FilterChip(
                      selected: includeReplies,
                      onSelected: (value) =>
                          ref.read(_showReplies.notifier).state = value,
                      label: const Text("Replies"),
                    )
                  ],
                ),
              ),
            ),
            TimelineSliver.user(
              userId: widget.id,
              includeReplies: includeReplies,
            ),
          ],
        ),
        CustomScrollView(
          slivers: [UserSliver.followers(userId: widget.id)],
        ),
        CustomScrollView(
          slivers: [UserSliver.following(userId: widget.id)],
        ),
      ],
    );
  }

  Widget buildTabBar() {
    return const TabBar(
      //isScrollable: true,
      tabs: [
        Tab(text: "Posts"),
        //Tab(text: "Media"),
        //Tab(text: "Likes"),
        Tab(text: "Followers"),
        Tab(text: "Following"),
      ],
    );
  }
}

class CustomSliverPersistentHeader extends SingleChildRenderObjectWidget {
  const CustomSliverPersistentHeader({super.key, required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderCustomSliverPersistentHeader();
}

class _RenderCustomSliverPersistentHeader
    extends RenderSliverPinnedPersistentHeader {
  @override
  double get maxExtent =>
      child!.getMaxIntrinsicHeight(constraints.crossAxisExtent);

  @override
  double get minExtent =>
      child!.getMaxIntrinsicHeight(constraints.crossAxisExtent);
}
