import "package:kaiteki/fediverse/api_type.dart";
import "package:kaiteki/fediverse/backends/mastodon/adapter.dart";
import "package:kaiteki/fediverse/backends/mastodon/client.dart";
import "package:kaiteki/fediverse/backends/mastodon/shared_adapter.dart";
import "package:kaiteki/fediverse/model/post/post.dart";
import "package:kaiteki/fediverse/model/timeline_kind.dart";
import "package:kaiteki/fediverse/model/timeline_query.dart";

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
    TimelineKind type, {
    TimelineQuery<String>? query,
  }) async {
    final statuses = await client.getTrendingStatuses();
    return statuses.map((e) => toPost(e, instance)).toList();
  }
}
