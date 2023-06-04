import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/error_landing_widget.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
import "package:kaiteki/ui/shared/posts/user_list_dialog.dart";
import "package:kaiteki/utils/extensions/build_context.dart";
import "package:kaiteki_core/social.dart";

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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          title: TextField(
            decoration: const InputDecoration(hintText: "Search"),
            textInputAction: TextInputAction.search,
            onSubmitted: _onSubmitted,
            autofocus: true,
          ),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                child: Row(
                  children: [
                    Icon(Icons.article_rounded),
                    SizedBox(width: 8),
                    Text("Posts"),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
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
                    return centeredCircularProgressIndicator;
                  }

                  final results = snapshot.data;

                  if (results == null) {
                    return const IconLandingWidget(
                      icon: Icon(Icons.search),
                      text: Text("Start typing to search"),
                    );
                  }

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
                            return InkWell(
                              onTap: () => context.showPost(post, ref),
                              child: PostWidget(post),
                            );
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
                            return UserListTile(
                              user: user,
                              onPressed: () => context.showUser(user, ref),
                            );
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
    );
  }

  void _onSubmitted(String query) {
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
