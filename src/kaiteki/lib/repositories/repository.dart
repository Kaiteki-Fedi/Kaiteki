abstract class Repository<T> {
  void remove(T item);
  void insert(T item);
  void removeAll();
  Iterable<T> getAll();
  Future<void> initialize();
  Future<bool> contains(T item);
}
