extension IterableExtensions<T> on Iterable<T> {
  T? firstOrDefault(bool test(T element)) {
    for (T element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  Map<K, Iterable<T>> groupBy<K>(K groupingFunction(T element)) {
    var map = Map<K, List<T>>();

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
