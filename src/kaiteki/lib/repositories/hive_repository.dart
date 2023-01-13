import "dart:async";

import "package:hive/hive.dart";
import "package:kaiteki/repositories/repository.dart";

class HiveRepository<T extends Object, K> extends Repository<T, K> {
  final Box<T> box;
  final dynamic Function(K key)? toHiveKeyConverter;
  final K Function(dynamic key)? fromHiveKeyConverter;

  HiveRepository(
    this.box, [
    this.fromHiveKeyConverter,
    this.toHiveKeyConverter,
  ]);

  @override
  Future<void> create(K key, T value) => box.put(_convertToHiveKey(key), value);

  @override
  Future<void> delete(K key) => box.delete(_convertToHiveKey(key));

  @override
  Map<K, T> read() {
    final entries = box.keys.map<MapEntry<K, T>>(
      (key) => MapEntry(
        _convertFromHiveKey(key),
        box.get(key)!,
      ),
    );
    return Map.fromEntries(entries.toList(growable: false));
  }

  @override
  Future<void> update(K key, T value) => create(key, value);

  dynamic _convertToHiveKey(K key) {
    final converter = toHiveKeyConverter;
    if (converter == null) return key;
    return converter(key)!;
  }

  K _convertFromHiveKey(dynamic key) {
    final converter = fromHiveKeyConverter;
    if (converter == null) return key as K;
    return converter(key)!;
  }
}
