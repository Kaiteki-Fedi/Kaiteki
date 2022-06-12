import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/ui/shared/icon_landing_widget.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';
import 'package:kaiteki/ui/user/constants.dart';
import 'package:kaiteki/ui/user/desktop_user_header.dart';
import 'package:kaiteki/ui/user/posts_page.dart';
import 'package:kaiteki/ui/user/user_info_widget.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:kaiteki/utils/layout_helper.dart';
import 'package:mdi/mdi.dart';

class UserScreen extends ConsumerStatefulWidget {
  final String id;
  final User? initialUser;

  const UserScreen.fromId(
    this.id, {
    Key? key,
  })  : initialUser = null,
        super(key: key);

  UserScreen.fromUser(
    User this.initialUser, {
    Key? key,
  })  : id = initialUser.id,
        super(key: key);

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Future<User> _future;
  ImageProvider? _bannerProvider;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);

    final bannerUrl = widget.initialUser?.bannerUrl;
    if (bannerUrl != null) {
      _bannerProvider = NetworkImage(bannerUrl);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final accounts = ref.watch(accountProvider);
    _future = accounts.adapter.getUserById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      initialData: widget.initialUser,
      future: _future,
      builder: (_, snapshot) {
        return LayoutBuilder(
          builder: (context, constraints) {
            switch (getScreenSize(constraints.maxWidth)) {
              case ScreenSize.xs:
              case ScreenSize.s:
                return _buildMobile(snapshot, constraints);
              case ScreenSize.m:
              case ScreenSize.l:
                return _buildDesktop(
                  context,
                  snapshot,
                  constraints,
                );
            }
          },
        );
      },
    );
  }

  Widget _buildDesktop(
    BuildContext context,
    AsyncSnapshot<User> snapshot,
    BoxConstraints constraints,
  ) {
    final user = snapshot.data;

    return Material(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              actions: buildActions(context, user: user),
              expandedHeight: user?.bannerUrl != null ? 450.0 : null,
              pinned: true,
              forceElevated: true,
              flexibleSpace: DesktopUserHeader(
                tabController: _tabController,
                tabs: buildTabs(context, user, true, Axis.horizontal),
                constraints: constraints,
                user: user,
                color: null,
              ),
            ),
          ];
        },
        body: ResponsiveLayoutBuilder(
          builder: (context, constraints, data) {
            return Row(
              children: [
                Flexible(
                  child: Column(
                    children: [
                      if (user != null)
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(columnPadding),
                              child: UserInfoWidget(user: user),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: gutter), // Gutter
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(columnPadding),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        PostsPage(
                          container: ref.watch(accountProvider),
                          widget: widget,
                        ),
                        Container(),
                        Container(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMobile(
    AsyncSnapshot<User> snapshot,
    BoxConstraints constraints,
  ) {
    final Widget body;

    if (snapshot.hasError) {
      body = const IconLandingWidget(
        icon: Icon(Mdi.accountAlert),
        text: Text("Failed retrieving account"),
      );
    } else if (!snapshot.hasData) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = TabBarView(
        controller: _tabController,
        children: [
          PostsPage(
            container: ref.watch(accountProvider),
            widget: widget,
          ),
          Container(),
          Container(),
        ],
      );
    }

    final isLoading = !(snapshot.hasData || snapshot.hasError);
    final tooSmall = constraints.minWidth < 600;

    return Scaffold(
      appBar: snapshot.hasData //
          ? _buildAppBar(
              !(tooSmall || isLoading),
              snapshot,
            )
          : AppBar(),
      body: body,
    );
  }

  List<Tab> buildTabs(
    BuildContext context,
    User? user,
    bool showCountBadges,
    Axis direction,
  ) {
    final l10n = context.getL10n();
    return [
      buildTab(
        l10n.postsTab,
        user?.postCount ?? 0,
        showCountBadges,
        direction,
      ),
      buildTab(
        l10n.followersTab,
        user?.followerCount ?? 0,
        showCountBadges,
        direction,
      ),
      buildTab(
        l10n.followingTab,
        user?.followingCount ?? 0,
        showCountBadges,
        direction,
      ),
    ];
  }

  Tab buildTab(String text, int count, bool showCountBadges, Axis direction) {
    if (direction == Axis.horizontal) {
      return Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            if (showCountBadges) buildBadge(context, count),
          ],
        ),
      );
    } else {
      final countLabel = shortenNumber(count);
      return Tab(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            const SizedBox(height: 4.0),
            Text(countLabel),
            const SizedBox(height: 4.0),
          ],
        ),
      );
    }
  }

  AppBar _buildAppBar(
    bool showCountBadges,
    AsyncSnapshot<User<dynamic>> snapshot,
  ) {
    final displayName = snapshot.data?.renderDisplayName(context);

    return AppBar(
      actions: buildActions(context, user: snapshot.data),
      bottom: TabBar(
        tabs: buildTabs(
          context,
          snapshot.data,
          showCountBadges,
          Axis.horizontal,
        ),
        controller: _tabController,
      ),
      title: snapshot.data == null
          ? const SizedBox()
          : Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: AvatarWidget(
                    snapshot.data!,
                    size: 24,
                  ),
                ),
                Flexible(
                  child: displayName == null
                      ? const Text("...")
                      : Text.rich(
                          displayName,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                ),
              ],
            ),
      flexibleSpace: FlexibleSpaceBar(
        background: _bannerProvider == null
            ? null
            : Opacity(
                opacity: 0.25,
                child: Image(
                  image: _bannerProvider!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox();
                  },
                ),
              ),
      ),
    );
  }

  String shortenNumber(int count) {
    var text = count.toString();

    if (count / 1000 >= 1) {
      text = '${(count / 1000).toStringAsFixed(2)}k';
    }

    return text;
  }

  Widget buildBadge(BuildContext context, int count) {
    final text = shortenNumber(count);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(left: 6.0),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      child: Text(
        text,
        style: GoogleFonts.robotoMono(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        textScaleFactor: 0.9,
        overflow: TextOverflow.fade,
      ),
    );
  }

  List<Widget> buildActions(BuildContext context, {User? user}) {
    final l10n = context.getL10n();
    final url = user?.url;

    return [
      IconButton(
        tooltip: l10n.openInBrowserLabel,
        icon: const Icon(Mdi.openInNew),
        onPressed: url == null ? null : () => context.launchUrl(url),
      ),
    ];
  }
}
