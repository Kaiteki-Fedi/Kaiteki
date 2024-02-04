import "dart:async";

import "package:kaiteki/di.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/model/pagination_state.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "bookmarks.g.dart";

@Riverpod(keepAlive: true, dependencies: [adapter, account])
class BookmarksService extends _$BookmarksService {
  late BookmarkSupport _adapter;

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
    return _adapter.getBookmarks(
      minId: query?.untilId,
      maxId: query?.sinceId,
    );
  }

  @override
  FutureOr<PaginationState<Post>> build(AccountKey key) async {
    _adapter = ref.watch(accountProvider(key))!.adapter as BookmarkSupport;
    final posts = await _fetch();
    return PaginationState(
      posts.toList(),
      canPaginateFurther: posts.isNotEmpty,
    );
  }

  Future<void> remove(String postId) async {
    await _adapter.unbookmarkPost(postId);

    final previousState = state.valueOrNull;
    if (previousState == null) return;

    state = AsyncValue.data(
      PaginationState(
        previousState.items.toList()
          ..removeWhere((element) => element.id == postId),
        canPaginateFurther: previousState.canPaginateFurther,
      ),
    );
  }

  Future<void> add(String postId) async {
    await _adapter.bookmarkPost(postId);

    final previousState = state.valueOrNull;
    if (previousState == null) return;

    ref.invalidateSelf();
  }
}
