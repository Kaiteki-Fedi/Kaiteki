import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/interfaces/search_support.dart';
import 'package:kaiteki/ui/shared/error_landing_widget.dart';
import 'package:kaiteki/ui/shared/icon_landing_widget.dart';
import 'package:kaiteki/ui/shared/posts/post_widget.dart';
import 'package:kaiteki/ui/shared/posts/user_list_dialog.dart';
import 'package:kaiteki/ui/shared/primary_tab_bar_theme.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  Future<SearchResults>? _results;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: PrimaryTabBarTheme(
        child: Scaffold(
          appBar: AppBar(
            title: TextField(
              decoration: const InputDecoration(hintText: "Search"),
              textInputAction: TextInputAction.search,
              onSubmitted: _onSubmitted,
              autofocus: true,
            ),
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab(
                  child: Row(
                    children: const [
                      Icon(Icons.article_rounded),
                      SizedBox(width: 8),
                      Text("Posts"),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: const [
                      Icon(Icons.person_rounded),
                      SizedBox(width: 8),
                      Text("Users"),
                    ],
                  ),
                ),
                // Tab(text: "Hashtags"),
              ],
            ),
          ),
          body: Column(
            children: [
              const Divider(height: 2),
              Expanded(
                child: FutureBuilder<SearchResults>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: ErrorLandingWidget.fromAsyncSnapshot(
                          snapshot,
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.connectionState == ConnectionState.none) {
                      return const IconLandingWidget(
                        icon: Icon(Icons.search),
                        text: Text("Start typing to search"),
                      );
                    }

                    final results = snapshot.data!;

                    return TabBarView(
                      children: [
                        if (results.posts.isEmpty)
                          const IconLandingWidget(
                            icon: Icon(Icons.article_outlined),
                            text: Text("No posts found"),
                          )
                        else
                          ListView.separated(
                            separatorBuilder: (context, i) {
                              return const Divider(height: 2);
                            },
                            itemBuilder: (context, i) {
                              final post = results.posts[i];
                              return PostWidget(post);
                            },
                            itemCount: results.posts.length,
                          ),
                        if (results.users.isEmpty)
                          const IconLandingWidget(
                            icon: Icon(Icons.person_outline_rounded),
                            text: Text("No users found"),
                          )
                        else
                          ListView.separated(
                            separatorBuilder: (context, i) {
                              return const Divider(height: 2);
                            },
                            itemBuilder: (context, i) {
                              final user = results.users[i];
                              return UserListTile(user: user);
                            },
                            itemCount: results.users.length,
                          ),
                        // Container(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmitted(query) {
    try {
      final adapter = ref.read(adapterProvider) as SearchSupport;
      setState(() {
        _results = adapter.search(query);
      });
    } catch (e, s) {
      setState(() {
        _results = Future.error(e, s);
      });
    }
  }
}
