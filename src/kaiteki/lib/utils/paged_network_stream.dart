import 'dart:async';

abstract class PagedNetworkStream<T, I> {
  final _controller = StreamController<List<T>>.broadcast();
  final _objects = new List<T>();

  I _lastId;
  Stream<Iterable<T>> stream;

  Future<Iterable<T>> fetchObjects(I firstId, I lastId);
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
    // TODO: Implement refresh adding items to the top.
    var objects = await fetchObjects(null, _lastId);

    _objects.addAll(objects);
    _controller.add(_objects);

    _lastId = takeId(objects.last);
  }
}
