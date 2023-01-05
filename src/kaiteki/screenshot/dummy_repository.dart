import 'dart:async';

import 'package:kaiteki/repositories/repository.dart';

class DummyRepository<T extends Object, K> extends Repository<T, K> {
  final Map<K, T> map = {};

  DummyRepository();

  @override
  FutureOr<void> create(K key, T value) {
    map[key] = value;
  }

  @override
  FutureOr<void> delete(K key) {
    if (map.containsKey(key)) {
      map.remove(key);
    }
  }

  @override
  FutureOr<Map<K, T>> read() => map;

  @override
  FutureOr<void> update(K key, T value) {
    map[key] = value;
  }
}
