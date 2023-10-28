import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/error_landing_widget.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
import "package:kaiteki/ui/shared/posts/user_list_dialog.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";

class SearchScreen extends ConsumerStatefulWidget {
  final String? query;

  const SearchScreen({super.key, this.query});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  Future<SearchResults>? _results;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final query = widget.query;

    if (query != null) {
      _controller.text = query;
      _onSubmitted(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          title: TextField(
            controller: _controller,
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
                  children: [
                    const Icon(Icons.article_rounded),
                    const SizedBox(width: 8),
                    Text(context.l10n.postsTab),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    const Icon(Icons.person_rounded),
                    const SizedBox(width: 8),
                    Text(context.l10n.usersTab),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    const Icon(Icons.tag_rounded),
                    const SizedBox(width: 8),
                    Text("Hashtags"),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: FutureBuilder<SearchResults>(
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

            if (results == null) return const SizedBox();

            return TabBarView(
              children: [
                if (results.posts.isEmpty)
                  IconLandingWidget(
                    icon: const Icon(Icons.article_outlined),
                    text: Text(context.l10n.postsTab),
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
                  IconLandingWidget(
                    icon: const Icon(Icons.person_outline_rounded),
                    text: Text(context.l10n.searchUsersNoResults),
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
                if (results.hashtags.isEmpty)
                  IconLandingWidget(
                    icon: const Icon(Icons.tag_rounded),
                    text: Text("No results"),
                  )
                else
                  ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final hashtag = results.hashtags[i];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          leading: const Icon(Icons.tag_rounded),
                          title: Text(hashtag),
                          onTap: () {
                            context.pushReplacementNamed(
                              "hashtag",
                              pathParameters: {
                                ...ref.accountRouterParams,
                                "hashtag": hashtag,
                              },
                            );
                          },
                        ),
                      );
                    },
                    itemCount: results.hashtags.length,
                  ),
              ],
            );
          },
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
