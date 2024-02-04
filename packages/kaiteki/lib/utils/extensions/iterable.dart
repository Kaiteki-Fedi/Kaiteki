extension IterableExtensions<T> on Iterable<T> {
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

  List<T> distinct([bool Function(T a, T b)? equals]) {
    final list = <T>[];

    final e = equals ?? (a, b) => a == b;
    for (final a in this) {
      if (!list.any((b) => e(a, b))) list.add(a);
    }

    return list;
  }
}
