extension IterableExtensions<T> on Iterable<T> {
  T? firstOrDefault(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  Map<K, Iterable<T>> groupBy<K>(K Function(T element) groupingFunction) {
    final map = <K, List<T>>{};

    for (final element in this) {
      final key = groupingFunction(element);

      if (!map.containsKey(key)) {
        map[key] = <T>[];
      }

      map[key]!.add(element);
    }

    return map;
  }
}
