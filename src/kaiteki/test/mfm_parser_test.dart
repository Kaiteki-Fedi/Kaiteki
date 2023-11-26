import "package:kaiteki/text/mfm_parser.dart";
import "package:test/test.dart";

void main() {
  test("tag only", () {
    final regions = parse(r"$[tag hello]").toList();
    expect(regions, hasLength(1));
    expect(regions[0].tag, equals("tag"));
    expect(regions[0].args, isEmpty);
    expect(regions[0].content, equals("hello"));
  });

  test("nested tag", () {
    final regions = parse(r"$[tag $[tag2 hello]]").toList();
    expect(regions, hasLength(1));
    expect(regions[0].tag, equals("tag"));
    expect(regions[0].args, isEmpty);
    expect(regions[0].content, equals(r"$[tag2 hello]"));
  });

  test("tag with args", () {
    final regions = parse(r"$[tag.key=value a]").toList();
    expect(regions, hasLength(1));
    expect(regions[0].tag, equals("tag"));
    expect(regions[0].args, equals({"key": "value"}));
    expect(regions[0].content, equals("a"));
  });

  test("tag with key-only args", () {
    final regions = parse(r"$[tag.key a]").toList();
    expect(regions, hasLength(1));
    expect(regions[0].tag, equals("tag"));
    expect(regions[0].args, equals({"key": null}));
    expect(regions[0].content, equals("a"));
  });

  test("tag with multiple args", () {
    final regions = parse(r"$[tag.a,b=2 a]").toList();
    expect(regions, hasLength(1));
    expect(regions[0].tag, equals("tag"));
    expect(regions[0].args, equals({"a": null, "b": "2"}));
    expect(regions[0].content, equals("a"));
  });

  test("consecutive tags", () {
    final regions = parse(r"$[tag a]$[tag a]").toList();
    expect(regions, hasLength(2));
  });
}
