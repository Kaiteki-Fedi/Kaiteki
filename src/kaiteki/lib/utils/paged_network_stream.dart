import 'dart:async';

abstract class PagedNetworkStream<T, I> {
  final _controller = StreamController<List<T>>.broadcast();
  final _objects = <T>[];

  I? _lastId;
  late final Stream<Iterable<T>> stream;

  bool _hasReachedEnd = false;

  bool get hasReachedEnd => _hasReachedEnd;

  Future<Iterable<T>> fetchObjects(I? firstId, I? lastId);

  I takeId(T object);

  PagedNetworkStream() {
    stream = _controller.stream;
    refresh();
  }

  Future<void> refresh() async {
    _objects.clear();
    _lastId = null;

    await loadMore();
  }

  Future<void> loadMore() async {
    // TODO(Craftplacer): Implement refresh adding items to the top.
    late final Iterable<T> objects;

    try {
      objects = await fetchObjects(null, _lastId);
    } catch (error) {
      _controller.addError(error);
      return;
    }

    if (objects.isNotEmpty) {
      _objects.addAll(objects);
      _lastId = takeId(objects.last);
    }

    _controller.add(_objects);

    _hasReachedEnd = _lastId != null && objects.isEmpty;
  }
}
