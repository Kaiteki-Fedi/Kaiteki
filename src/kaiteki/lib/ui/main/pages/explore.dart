import "package:flutter/material.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
import "package:kaiteki/ui/window_class.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";
import "package:kaiteki_core/utils.dart";
import "package:url_launcher/url_launcher.dart";

final trendingLinksProvider = FutureProvider<List<Embed>?>(
  (ref) async {
    final explore = ref.watch(adapterProvider).safeCast<ExploreSupport>();

    if (explore == null || !explore.capabilities.supportsTrendingLinks) {
      return null;
    }

    return explore.getTrendingLinks();
  },
  dependencies: [adapterProvider],
);

final trendingHashtagsProvider = FutureProvider<List<String>?>(
  (ref) async {
    final explore = ref.watch(adapterProvider).safeCast<ExploreSupport>();
    if (explore == null) return null;
    return explore.getTrendingHashtags();
  },
  dependencies: [adapterProvider],
);

final trendingPostsProvider = FutureProvider<List<Post>?>(
  (ref) async {
    final explore = ref.watch(adapterProvider).safeCast<ExploreSupport>();
    if (explore == null) return null;
    return explore.getTrendingPosts();
  },
  dependencies: [adapterProvider],
);

class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    final cards = buildCards(context);
    final windowClass = WindowClass.fromContext(context);

    if (windowClass <= WindowClass.medium) {
      return ListView(
        padding: const EdgeInsets.all(16.0),
        children: cards.joinWithValue(const SizedBox(height: 16)),
      );
    }

    return MasonryGridView.count(
      padding: const EdgeInsets.all(16.0),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 8,
      itemBuilder: (context, index) => cards[index],
      itemCount: cards.length,
    );
  }

  List<Widget> buildCards(BuildContext context) {
    final explore = ref.watch(adapterProvider).safeCast<ExploreSupport>();
    return <Widget>[
      buildTrendingPosts(context),
      // buildTrendingHashtags(context),
      if (explore?.capabilities.supportsTrendingLinks ?? false)
        buildNews(context),
    ];
  }

  Widget buildNews(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "News",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        ref.watch(trendingLinksProvider).map(
              data: (data) {
                final cards = data.value
                    ?.map<Widget>((e) => NewsCard(embed: e))
                    .toList()
                    .joinWithValue(const SizedBox(height: 8));
                return Column(
                  children: cards ?? [],
                );
              },
              error: (_) => const SizedBox(),
              loading: (_) => Column(
                children: <Widget>[
                  for (int i = 0; i < 3; i++) const NewsCard(embed: null),
                ].joinWithValue(const SizedBox(height: 8)),
              ),
            ),
      ],
    );
  }

  Widget buildTrendingPosts(BuildContext context) {
    final trendingPosts = ref.watch(trendingPostsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Trending right now",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        trendingPosts.map(
          data: (data) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ref.watch(trendingHashtagsProvider).map(
                    data: (data) => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        for (final hashtag in data.value!)
                          ActionChip(
                            // ignore: l10n
                            label: Text("#$hashtag"),
                            onPressed: () {
                              context.pushNamed(
                                "hashtag",
                                pathParameters: {
                                  ...ref.accountRouterParams,
                                  "hashtag": hashtag,
                                },
                              );
                            },
                          ),
                      ],
                    ),
                    error: (_) => const SizedBox(),
                    loading: (_) => const Row(),
                  ),
              const SizedBox(height: 8),
              for (final post in data.value!.take(3))
                Card(
                  child: PostWidget(
                    post,
                    layout: PostWidgetLayout.wide,
                  ),
                ),
            ].joinWithValue(const SizedBox(height: 8)),
          ),
          error: (_) => const SizedBox(),
          loading: (_) => const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: LinearProgressIndicator(),
          ),
        ),
      ],
    );
  }

// Widget buildTrendingHashtags(BuildContext context) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.stretch,
//     children: [
//       Text(
//         "Trends",
//         style: Theme.of(context).textTheme.headlineSmall,
//       ),
//       const SizedBox(height: 16),
//       FutureBuilder(
//         future: ,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return const SizedBox();
//
//           final hashtags = snapshot.data!.take(5).toList();
//           return Card(
//             child: Column(
//               children: <Widget>[
//                 for (var i = 0; i < hashtags.length; i++)
//                   ListTile(
//                     title: Text("#${hashtags[i]}"),
//                   ),
//               ].joinWithValue(const SizedBox(height: 8)),
//             ),
//           );
//         },
//       ),
//     ],
//   );
// }
}

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.embed,
  });

  final Embed? embed;

  @override
  Widget build(BuildContext context) {
    final placeholder = Center(
      child: Icon(
        Icons.newspaper_rounded,
        color: Theme.of(context).colorScheme.onInverseSurface,
      ),
    );

    final title = embed?.title;
    final description = embed?.description;
    final siteName = embed?.siteName;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: embed?.uri.nullTransform(
          (url) => () async {
            await launchUrl(
              url,
              mode: LaunchMode.externalApplication,
            );
          },
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 8),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: ColoredBox(
                      color: Theme.of(context).colorScheme.inverseSurface,
                      child: embed?.imageUrl.nullTransform(
                            (url) => Image.network(
                              url.toString(),
                              fit: BoxFit.cover,
                            ),
                          ) ??
                          placeholder,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (siteName != null) ...[
                      Text(
                        siteName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).colorScheme.outline.textStyle,
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (title != null)
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (description != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
