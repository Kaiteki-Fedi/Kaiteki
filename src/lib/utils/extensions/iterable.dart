extension IterableExtensions<T> on Iterable<T> {
  T firstOrDefault(bool test(T element)) {
    for (T element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}