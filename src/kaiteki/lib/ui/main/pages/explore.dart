import "dart:math";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/explore/news_list_tile.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";
import "package:kaiteki_core/utils.dart";
import "package:sliver_tools/sliver_tools.dart";
import "package:url_launcher/url_launcher.dart";

const _kPostLimit = 3;

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
  bool _expandPosts = false;

  @override
  Widget build(BuildContext context) {
    final explore = ref.watch(adapterProvider).safeCast<ExploreSupport>();

    return Material(
      child: CustomScrollView(
        primary: true,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            sliver: SliverCrossAxisConstrained(
              maxCrossAxisExtent: 600,
              child: SliverMainAxisGroup(
                slivers: [
                  ...buildTrendingPosts(context),
                  if (explore?.capabilities.supportsTrendingLinks ?? false)
                    ...buildNews(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Iterable<Widget> buildNews(BuildContext context) sync* {
    yield const SliverToBoxAdapter(child: SizedBox(height: 16));

    yield SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          "News",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );

    yield const SliverToBoxAdapter(child: SizedBox(height: 16));

    final trendingLinks = ref.watch(trendingLinksProvider);
    yield trendingLinks.map(
      data: (data) {
        return SliverList.separated(
          itemBuilder: (_, i) => NewsListTile(embed: data.value![i]),
          separatorBuilder: (_, __) => const Divider(),
          itemCount: data.value?.length ?? 0,
        );
      },
      error: (_) => const SliverToBoxAdapter(child: SizedBox()),
      loading: (_) => SliverToBoxAdapter(
        child: Column(
          children: <Widget>[
            for (int i = 0; i < 3; i++) const NewsCard(embed: null),
          ].joinWithValue(const SizedBox(height: 8)),
        ),
      ),
    );
  }

  Iterable<Widget> buildTrendingPosts(BuildContext context) sync* {
    yield SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          "Trending right now",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
    yield const SliverToBoxAdapter(child: SizedBox(height: 16));

    final trendingHashtags = ref.watch(trendingHashtagsProvider);
    yield trendingHashtags.map(
      data: (data) => SliverToBoxAdapter(
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            for (int i = 0; i < data.value!.length; i++)
              _HashtagChip(data.value![i]),
          ],
        ),
      ),
      error: (_) => const SliverToBoxAdapter(child: SizedBox()),
      loading: (_) => SliverToBoxAdapter(
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            for (int i = 0; i < 10; i++)
              // ignore: l10n
              const ActionChip(label: Text("...")),
          ],
        ),
      ),
    );

    yield const SliverToBoxAdapter(child: SizedBox(height: 8));

    final trendingPosts = ref.watch(trendingPostsProvider);
    if (trendingPosts.valueOrNull != null) {
      yield trendingPosts.map(
        data: (data) {
          final posts = data.requireValue!;
          return SliverList.separated(
            itemCount:
                _expandPosts ? posts.length : min(posts.length, _kPostLimit),
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostWidget(
                post,
                onOpen: () => context.showPost(post, ref),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 8),
          );
        },
        error: (_) => const SliverToBoxAdapter(child: SizedBox()),
        loading: (_) => const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: LinearProgressIndicator(),
          ),
        ),
      );

      final postCount = trendingPosts.value!.length;
      if (postCount > _kPostLimit) {
        yield SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: TextButton(
                onPressed: () => setState(() => _expandPosts = !_expandPosts),
                child: _expandPosts
                    ? Text("Show fewer posts")
                    : Text("Show ${postCount - _kPostLimit} more"),
              ),
            ),
          ),
        );
      }
    }
  }
}

class _HashtagChip extends ConsumerWidget {
  const _HashtagChip(this.hashtag, {super.key});

  final String hashtag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ActionChip(
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
    );
  }
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
