import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  final User? initialUser;

  const AccountScreen.fromId(this.id) : initialUser = null;

  AccountScreen.fromUser(User this.initialUser) : id = initialUser.id;

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

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
          initialData: widget.initialUser,
          future: Future<User<dynamic>>.delayed(
            const Duration(seconds: 5),
            () async => container.adapter.getUserById(widget.id),
          ),
          builder: (_, AsyncSnapshot<User> snapshot) {
            var isLoading = !(snapshot.hasData || snapshot.hasError);
            var tooSmall = constraints.minWidth < 600;

            return Scaffold(
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
              appBar: _buildAppBar(
                isLoading,
                !(tooSmall || isLoading),
                snapshot,
              ),
            );
          },
        );
      },
    );
  }

  AppBar _buildAppBar(
    bool isLoading,
    bool showCountBadges,
    AsyncSnapshot<User<dynamic>> snapshot,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      bottom: TabBar(
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.postsTab),
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
                Text(l10n.followersTab),
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
                Text(l10n.followingTab),
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
          if (isLoading) const LinearProgressIndicator(),
        ],
      ),
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
      margin: const EdgeInsets.only(left: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
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
      initialData: const <Post>[],
      builder: (BuildContext context, AsyncSnapshot<Iterable<Post>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
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
            Text.rich(
              TextSpan(
                children: [
                  TextRenderer(
                    emojis: account.emojis,
                    theme: TextRendererTheme.fromContext(context),
                  ).renderFromHtml(context, account.description!)
                ],
                style: const TextStyle(
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
