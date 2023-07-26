import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:meta/meta.dart";

@immutable
class PaginationState<T> {
  final List<T> items;
  final bool canPaginateFurther;

  const PaginationState(this.items, {this.canPaginateFurther = true});
}

extension AsyncValueToPagingState<T> on AsyncValue<PaginationState<T>> {
  PagingState<S, T> getPagingState<S>(S? nextPageKey) {
    return map(
      loading: (loading) => PagingState(
        nextPageKey: nextPageKey,
        itemList: loading.valueOrNull?.items,
      ),
      data: (data) => PagingState(
        nextPageKey: data.value.canPaginateFurther ? nextPageKey : null,
        itemList: data.value.items,
      ),
      error: (error) => PagingState(error: error.error),
    );
  }
}
