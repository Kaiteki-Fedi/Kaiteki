import "dart:async";

import "package:kaiteki/di.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/model/pagination_state.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:kaiteki/ui/shared/timeline/source.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "timeline.g.dart";

@Riverpod(keepAlive: true, dependencies: [adapter, account])
class TimelineService extends _$TimelineService {
  late TimelineSource _source;
  late BackendAdapter _adapter;
  StreamSubscription<TimelineEvent>? _stream;

  Future<void> loadMore() async {
    final previousState = state.valueOrNull;

    if (previousState == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        if (previousState.items.isEmpty) {
          return PaginationState(
            previousState.items,
            canPaginateFurther: false,
          );
        }

        final query = TimelineQuery(untilId: previousState.items.last.id);
        final page = await _fetch(query);
        return PaginationState(
          [...previousState.items, ...page],
          canPaginateFurther: page.isNotEmpty,
        );
      },
    );
  }

  Future<Iterable<Post>> _fetch([TimelineQuery<String>? query]) {
    return _source.fetch(_adapter, query);
  }

  @override
  FutureOr<PaginationState<Post>> build(
    AccountKey key,
    TimelineSource source,
  ) async {
    final adapter = ref.watch(accountProvider(key))!.adapter;
    _adapter = adapter;
    _source = source;
    final posts = await _fetch();

    ref.onDispose(() {
      _stream?.cancel();
    });

    if (adapter is StreamSupport && source is StandardTimelineSource && ref.read(AppExperiment.timelineStreaming.provider)) {
      final streaming = adapter as StreamSupport;
      _stream = streaming.listenToTimeline(source.type).listen((event) {
        final previousState = state.valueOrNull;

        if (previousState == null) return;

        switch (event) {
          case PostEvent():
            state = AsyncValue.data(
              PaginationState(
                [event.post, ...previousState.items],
                canPaginateFurther: previousState.canPaginateFurther,
              ),
            );
          case PostDeletedEvent():
            state = AsyncValue.data(
              PaginationState(
                previousState.items.where((e) => e.id != event.id).toList(),
                canPaginateFurther: previousState.canPaginateFurther,
              ),
            );
            return;
          case PostEditedEvent():
            var list = previousState.items;

            int index = list.indexWhere((e) => e.id == event.post.id);

            if (index == -1) {
              list = [event.post, ...previousState.items];
            } else {
              list..removeAt(index)
              ..insert(index, event.post);
            }

            state = AsyncValue.data(
              PaginationState(
                list,
                canPaginateFurther: previousState.canPaginateFurther,
              ),
            );
            return;
        }
      });
    }

    return PaginationState(
      posts.toList(),
      canPaginateFurther: posts.isNotEmpty,
    );
  }
}
