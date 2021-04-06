import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/ui/widgets/status_widget.dart';
import 'package:kaiteki/utils/text/text_renderer.dart';
import 'package:kaiteki/utils/text/text_renderer_theme.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  final String id;

  AccountScreen(this.id);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {
  var _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    var container = Provider.of<AccountManager>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return FutureBuilder(
          future: Future<User<dynamic>>.delayed(
            Duration(seconds: 5),
            () async => container.adapter.getUserById(widget.id),
          ),
          builder: (_, AsyncSnapshot<User> snapshot) {
            var isLoading = !(snapshot.hasData || snapshot.hasError);
            var tooSmall = constraints.minWidth < 600;

            return Scaffold(
              body: NestedScrollView(
                headerSliverBuilder: (_, __) => [
                  buildSliverAppBar(
                    isLoading,
                    !(tooSmall || isLoading),
                    snapshot,
                  ),
                ],
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    PostsPage(
                      isLoading: isLoading,
                      container: container,
                      widget: widget,
                    ),
                    Container(),
                    Container(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  SliverAppBar buildSliverAppBar(
    bool isLoading,
    bool showCountBadges,
    AsyncSnapshot<User<dynamic>> snapshot,
  ) {
    return SliverAppBar(
      pinned: true,
      bottom: TabBar(
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("POSTS"),
                if (showCountBadges)
                  buildBadge(
                    context,
                    snapshot.data!.postCount ?? 0,
                  ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("FOLLOWERS"),
                if (showCountBadges)
                  buildBadge(
                    context,
                    snapshot.data!.followerCount ?? 0,
                  ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("FOLLOWING"),
                if (showCountBadges)
                  buildBadge(
                    context,
                    snapshot.data!.followingCount ?? 0,
                  ),
              ],
            ),
          ),
        ],
        controller: _tabController,
      ),
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              maxRadius: 14,
              child: isLoading
                  ? null
                  : Image.network(
                      snapshot.data!.avatarUrl!,
                    ),
            ),
          ),
          Text(
            snapshot.data?.displayName ?? "",
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {},
            child: Text("FOLLOW"),
          ),
        ),
      ],
      flexibleSpace: Stack(
        children: [
          FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: isLoading || snapshot.data!.bannerUrl != null
                ? null
                : Image.network(
                    snapshot.data!.bannerUrl!,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
          ),
          if (isLoading) LinearProgressIndicator(),
        ],
      ),
      expandedHeight: 250,
      toolbarHeight: 54,
    );
  }

  Widget buildBadge(BuildContext context, int count) {
    var text = count.toString();

    if (count / 1000 >= 1) {
      text = (count / 1000).toStringAsFixed(2) + 'k';
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(left: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
      child: Text(
        text,
        style: GoogleFonts.robotoMono(color: Colors.black),
        overflow: TextOverflow.fade,
      ),
    );
  }
}

class PostsPage extends StatelessWidget {
  const PostsPage({
    Key? key,
    required this.isLoading,
    required this.container,
    required this.widget,
  }) : super(key: key);

  final bool isLoading;
  final AccountManager container;
  final AccountScreen widget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          isLoading ? null : container.adapter.getStatusesOfUserById(widget.id),
      initialData: <Post>[],
      builder: (BuildContext context, AsyncSnapshot<Iterable<Post>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        return ListView.builder(
          itemBuilder: (_, int i) => StatusWidget(snapshot.data!.elementAt(i)),
          itemCount: snapshot.data?.length ?? 0,
        );
      },
    );
  }
}

class AccountHeader extends StatelessWidget {
  const AccountHeader({
    Key? key,
    required this.account,
  }) : super(key: key);

  final User account;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(image: getDecorationBackground(account)),
      child: Column(
        children: [
          Row(
            children: [
              Image.network(account.avatarUrl!, width: 56, height: 56),
              Padding(
                padding: const EdgeInsets.only(left: 8.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(account.displayName),
                    Text('@' + account.username),
                  ],
                ),
              )
            ],
          ),
          if (account.description != null)
            RichText(
              text: TextSpan(
                children: [
                  TextRenderer(
                    emojis: account.emojis,
                    theme: TextRendererTheme.fromContext(context),
                  ).renderFromHtml(account.description!)
                ],
                style: TextStyle(
                  shadows: [Shadow(blurRadius: 2, offset: Offset(0, 1))],
                ),
              ),
            ),
        ],
      ),
    );
  }

  DecorationImage? getDecorationBackground(User account) {
    if (account.bannerUrl == null) return null;

    return DecorationImage(
      fit: BoxFit.cover,
      image: NetworkImage(account.bannerUrl!),
    );
  }
}
