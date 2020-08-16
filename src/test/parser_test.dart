import 'package:flutter_test/flutter_test.dart';
import 'package:kaiteki/utils/tag.dart';

void main() {
  group("tag name parsing", () {
    test('Tag is "a" (normal)', () {
      Tag tag = Tag.parse("a");
      expect(tag.name, "a");
    });

    test('Tag is "a" (spaced)', () {
      Tag tag = Tag.parse(" a ");
      expect(tag.name, "a");
    });
  });

  group("attribute parsing", () {
    test('"a" tag with attribute', () {
      Tag tag = Tag.parse("a key");
      expect(tag.name, "a");
      expect(tag.attributes.containsKey("key"), true);
    });

    test('"a" tag with value attribute', () {
      Tag tag = Tag.parse("a key=value");
      expect(tag.name, "a");
      expect(tag.attributes.containsKey("key"), true);
      expect(tag.attributes["key"], "value");
    });

    test('"a" tag with string value attribute', () {
      Tag tag = Tag.parse('a key="value"');
      expect(tag.name, "a");
      expect(tag.attributes.containsKey("key"), true);
      expect(tag.attributes["key"], "value");
    });

    test('"a" tag with empty string value attribute', () {
      Tag tag = Tag.parse('a key=""');
      expect(tag.name, "a");
      expect(tag.attributes.containsKey("key"), true);
      expect(tag.attributes["key"], null);
    });
  });

  test("tag is ending", () {
    Tag tag = Tag.parse('/a');
    expect(tag.isClosing, true);
  });
}