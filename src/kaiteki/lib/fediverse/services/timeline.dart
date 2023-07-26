import "dart:async";

import "package:kaiteki/di.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/model/pagination_state.dart";
import "package:kaiteki/ui/shared/timeline/source.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "timeline.g.dart";

@Riverpod(keepAlive: true, dependencies: [adapter, account])
class TimelineService extends _$TimelineService {
  late TimelineSource _source;
  late BackendAdapter _adapter;

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        final posts = await _fetch();
        return PaginationState(posts.toList());
      },
    );
  }

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
        return PaginationState([...previousState.items, ...page]);
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
    _adapter = ref.watch(accountProvider(key))!.adapter;
    _source = source;
    final posts = await _fetch();
    return PaginationState(posts.toList());
  }
}
