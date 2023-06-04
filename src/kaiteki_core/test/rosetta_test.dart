import 'package:kaiteki_core/src/rosetta.dart';
import 'package:test/test.dart';

void main() {
  final rosetta = Rosetta(
    const {0: 'a', 1: 'b', 2: 'c'},
  );

  group('Rosetta with values', () {
    test('test left', () => expect(rosetta.getLeft('b'), equals(1)));
    test('test right', () => expect(rosetta.getRight(1), equals('b')));
    test('test left out of bounds', () {
      expect(
        () => rosetta.getLeft('d'),
        throwsA(const TypeMatcher<MissingRosettaValueException>()),
      );
    });
    test('test right out of bounds', () {
      expect(
        () => rosetta.getRight(3),
        throwsA(const TypeMatcher<MissingRosettaValueException>()),
      );
    });
  });

  test('test rosetta instantiation without values', () {
    expect(
      () => Rosetta(const {}),
      throwsA(const TypeMatcher<ArgumentError>()),
    );
  });
}
