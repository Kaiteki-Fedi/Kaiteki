import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:meta/meta.dart";

@immutable
class PaginationState<T> {
  final List<T> items;
  final bool canPaginateFurther;

  const PaginationState(this.items, {required this.canPaginateFurther});
}

extension AsyncValueToPagingState<T> on AsyncValue<PaginationState<T>> {
  PagingState<S, T> getPagingState<S>(
    S? nextPageKey, {
    List<T> Function(List<T> items)? intercept,
  }) {
    List<T>? magic(List<T>? items) {
      if (items == null) return null;
      if (intercept == null) return items;
      return intercept(items);
    }

    return map(
      loading: (loading) => PagingState(
        nextPageKey: nextPageKey,
        itemList: magic(loading.valueOrNull?.items),
      ),
      data: (data) => PagingState(
        nextPageKey: data.value.canPaginateFurther ? nextPageKey : null,
        itemList: magic(data.value.items),
      ),
      error: (error) => PagingState(error: (error.error, error.stackTrace)),
    );
  }
}
