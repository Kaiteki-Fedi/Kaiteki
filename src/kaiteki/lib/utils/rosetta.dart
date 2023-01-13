import "dart:collection";

import "package:collection/collection.dart";
import "package:meta/meta.dart";

@immutable
class Rosetta<Left, Right> {
  final HashSet<MapEntry<Left, Right>> _set;

  factory Rosetta(Map<Left, Right> map) => Rosetta.fromIterable(map.entries);

  factory Rosetta.fromIterable(Iterable<MapEntry<Left, Right>> set) {
    if (set.isEmpty) {
      throw ArgumentError.value(set, "set", "Set must not be empty.");
    }
    return Rosetta._(HashSet.from(set));
  }

  const Rosetta._(this._set);

  Right getRight(Left left) {
    final right = tryGetRight(left);
    if (right == null) throw MissingRosettaValueException(left, Left);
    return right;
  }

  Left getLeft(Right right) {
    final left = tryGetLeft(right);
    if (left == null) throw MissingRosettaValueException(right, Left);
    return left;
  }

  Left? tryGetLeft(Right right) {
    return _set.firstWhereOrNull((e) => e.value == right)?.key;
  }

  Right? tryGetRight(Left left) {
    return _set.firstWhereOrNull((e) => e.key == left)?.value;
  }
}

class MissingRosettaValueException<T> implements Exception {
  final String message;

  factory MissingRosettaValueException(T value, Type other) {
    return MissingRosettaValueException._(
      "Couldn't find a corresponding $other for ${value.runtimeType} $value",
    );
  }

  MissingRosettaValueException._(this.message);

  @override
  String toString() => message;
}
