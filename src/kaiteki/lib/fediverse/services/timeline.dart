import "dart:async";

import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/timeline/source.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "timeline.g.dart";

typedef TimelineServiceState = ({Iterable<Post> posts, bool hasReachedEnd});

@Riverpod(keepAlive: true, dependencies: [adapter])
class TimelineService extends _$TimelineService {
  late TimelineSource _source;

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async => (posts: await _fetch(), hasReachedEnd: false),
    );
  }

  Future<void> loadMore() async {
    final previousState = state.valueOrNull;

    if (previousState == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        if (previousState.posts.isEmpty) {
          return (posts: previousState.posts, hasReachedEnd: true);
        }

        final query = TimelineQuery(untilId: previousState.posts.last.id);
        final page = await _fetch(query);
        return (posts: [...previousState.posts, ...page], hasReachedEnd: false);
      },
    );
  }

  Future<Iterable<Post>> _fetch([TimelineQuery<String>? query]) {
    final adapter = ref.watch(adapterProvider);
    return _source.fetch(adapter, query);
  }

  @override
  FutureOr<TimelineServiceState> build(TimelineSource source) async {
    _source = source;
    return (posts: await _fetch(), hasReachedEnd: false);
  }
}
