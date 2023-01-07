import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/user/user.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';
import 'package:kaiteki/ui/shared/timeline.dart';
import 'package:kaiteki/ui/user/user_panel.dart';
import 'package:kaiteki/ui/user/user_sliver.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:share_plus/share_plus.dart';

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
    final displayName = user.displayName;
    return ListTile(
      title: displayName == null
          ? Text(
              user.username,
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
            )
          : Text.rich(
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
    final placeholder = Flexible(
      child: ColoredBox(color: Colors.black.withOpacity(.125)),
    );

    if (user == null || user.bannerUrl == null) return placeholder;

    return Image.network(
      user.bannerUrl!,
      fit: BoxFit.cover,
      color: Colors.white.withOpacity(0.5),
      colorBlendMode: BlendMode.modulate,
      isAntiAlias: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    const avatarSize = 72.0;
    const bannerHeight = 8.0 * 16.0;
    return DefaultTabController(
      length: 3,
      child: FutureBuilder<User>(
        future: _future,
        builder: (context, snapshot) {
          final user = snapshot.data;
          final includeReplies = ref.watch(_showReplies);
          return Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    actions: [
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () async {
                              final url = user?.url;
                              if (url != null) await Share.share(url);
                            },
                            enabled: user?.url != null,
                            child: const Text("Share"),
                          ),
                        ],
                      ),
                    ],
                    title: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      child: !innerBoxIsScrolled
                          ? null
                          : user?.nullTransform(_buildAppBarUserName),
                    ),
                    pinned: true,
                    forceElevated: innerBoxIsScrolled,
                    expandedHeight: bannerHeight + (avatarSize / 2),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Padding(
                            padding: !innerBoxIsScrolled
                                ? const EdgeInsets.only(
                                    bottom: avatarSize / 2,
                                  )
                                : EdgeInsets.zero,
                            child: _buildBanner(user),
                          ),
                          if (user != null && !innerBoxIsScrolled)
                            Positioned(
                              left: 16.0,
                              bottom: 0,
                              child: AvatarWidget(user, size: avatarSize),
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
                      color: Theme.of(context).colorScheme.surface,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          TabBar(
                            //isScrollable: true,
                            tabs: [
                              Tab(text: "Posts"),
                              //Tab(text: "Media"),
                              //Tab(text: "Likes"),
                              Tab(text: "Followers"),
                              Tab(text: "Following"),
                            ],
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: CheckboxListTile(
                          value: includeReplies,
                          onChanged: (value) =>
                              ref.read(_showReplies.notifier).state = value!,
                          title: const Text("Show replies"),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      const SliverToBoxAdapter(child: Divider()),
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
              ),
            ),
          );
        },
      ),
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
