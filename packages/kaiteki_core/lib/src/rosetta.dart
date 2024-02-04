import 'package:meta/meta.dart';
import 'package:quiver/collection.dart';

/// A [Rosetta] is a bidirectional mapping between two types.
///
/// It can be used to convert values of one type to values of another type.
///
/// This class is immutable. To create a [Rosetta], use [Rosetta.fromEntries].
/// [Left] and [Right] can be any type. They do not need to be the same type.
///
/// ```dart
/// final rosetta = Rosetta(
///   const {0: "a", 1: "b", 2: "c"},
/// );
///
/// // Get the corresponding right value for a left value.
/// rosetta.getRight(1); // "b"
///
/// // Get the corresponding left value for a right value.
/// rosetta.getLeft("c"); // 2
///
/// // If there is no corresponding value, a [MissingRosettaValueException] is thrown.
/// rosetta.getLeft("d"); // throws MissingRosettaValueException
/// rosetta.getRight(3); // throws MissingRosettaValueException
///
/// // You can also use the tryGetLeft and tryGetRight methods which return null
/// // instead of throwing an exception.
/// rosetta.tryGetLeft("d"); // null
/// rosetta.tryGetRight(3); // null
/// ```
///
/// Its name is inspired by the [Rosetta Stone](https://en.wikipedia.org/wiki/Rosetta_Stone)
/// which is a stele with the same text written in three different languages.
///
/// Internally, a [Rosetta] uses a [BiMap] to store the mapping but exposes
/// a simpler and more restricted API. Mutation is not allowed thus methods like
/// [BiMap.add] are not exposed.
///
/// See also:
/// - [MissingRosettaValueException]
@immutable
class Rosetta<Left, Right> {
  final BiMap<Left, Right> _map;

  factory Rosetta(Map<Left, Right> map) => Rosetta.fromEntries(map.entries);

  factory Rosetta.fromEntries(Iterable<MapEntry<Left, Right>> entries) {
    if (entries.isEmpty) {
      throw ArgumentError.value(
        entries,
        'entries',
        'Entries must not be empty.',
      );
    }
    return Rosetta._(HashBiMap()..addEntries(entries));
  }

  const Rosetta._(this._map);

  Right getRight(Left left) {
    final right = tryGetRight(left);
    if (right == null) throw MissingRosettaValueException(left, Right);
    return right;
  }

  Left getLeft(Right right) {
    final left = tryGetLeft(right);
    if (left == null) throw MissingRosettaValueException(right, Left);
    return left;
  }

  Left? tryGetLeft(Right right) => _map.inverse[right];

  Right? tryGetRight(Left left) => _map[left];
}

class MissingRosettaValueException<T> implements Exception {
  final String message;

  factory MissingRosettaValueException(T value, Type other) {
    return MissingRosettaValueException._(
      'Couldn\'t find a corresponding $other for ${value.runtimeType} '
      'value $value.',
    );
  }

  const MissingRosettaValueException._(this.message);

  @override
  String toString() => 'MissingRosettaValueException: $message';
}
