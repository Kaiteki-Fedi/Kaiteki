import "dart:async";

abstract class Repository<T extends Object, K> {
  FutureOr<void> create(K key, T value);
  FutureOr<void> delete(K key);
  FutureOr<void> update(K key, T value);
  FutureOr<Map<K, T>> read();
}
