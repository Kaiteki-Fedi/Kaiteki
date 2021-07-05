extension IterableExtensions<T> on Iterable<T> {
  T? firstOrDefault(bool Function(T element) test) {
    for (T element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  Map<K, Iterable<T>> groupBy<K>(K Function(T element) groupingFunction) {
    var map = <K, List<T>>{};

    for (T element in this) {
      var key = groupingFunction(element);

      if (!map.containsKey(key)) {
        map[key] = <T>[];
      }

      map[key]!.add(element);
    }

    return map;
  }
}
