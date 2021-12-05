import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/ui/widgets/posts/avatar_widget.dart';
import 'package:kaiteki/ui/widgets/status_widget.dart';
import 'package:kaiteki/utils/text/text_renderer.dart';
import 'package:kaiteki/utils/text/text_renderer_theme.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  final String id;
  final User? initialUser;

  const AccountScreen.fromId(
    this.id, {
    Key? key,
  })  : initialUser = null,
        super(key: key);

  AccountScreen.fromUser(
    User this.initialUser, {
    Key? key,
  })  : id = initialUser.id,
        super(key: key);

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
    final container = Provider.of<AccountManager>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return FutureBuilder(
          initialData: widget.initialUser,
          future: container.adapter.getUserById(widget.id),
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
    final bannerUrl = snapshot.data?.bannerUrl;

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
      title: snapshot.data == null
          ? const SizedBox()
          : Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: AvatarWidget(
                    snapshot.data!,
                    size: 24,
                    openOnTap: false,
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
            background: bannerUrl == null
                ? null
                : Image.network(
                    bannerUrl,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox();
                    },
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
