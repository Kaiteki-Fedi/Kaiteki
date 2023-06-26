import "package:kaiteki_core/backends/mastodon.dart";
import "package:kaiteki_core/kaiteki_core.dart";

class TrendingMastodonAdapter extends MastodonAdapter {
  factory TrendingMastodonAdapter(String instance) {
    return TrendingMastodonAdapter.custom(
      ApiType.mastodon,
      instance,
      MastodonClient(instance),
    );
  }

  TrendingMastodonAdapter.custom(
    super.type,
    super.instance,
    super.client,
  ) : super.custom();

  @override
  Future<List<Post>> getTimeline(
    TimelineType type, {
    TimelineQuery<String>? query,
  }) async =>
      getTrendingPosts();
}
