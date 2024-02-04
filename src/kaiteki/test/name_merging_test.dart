import "package:kaiteki/utils/name_merging.dart";
import "package:test/test.dart";

void main() {
  test("separated", () {
    final content = mergeName("Wonderful Alice", "alice", "example.org");
    expect(content, isNotNull);
    expect(content!.$2, equals("@alice@example.org"));
  });

  test("unseparated", () {
    final content = mergeName("Alice", "alice", "example.org");
    expect(content, isNotNull);
    expect(content!.$1, equals("Alice"));
    expect(content.$2, equals("@example.org"));
  });
}
