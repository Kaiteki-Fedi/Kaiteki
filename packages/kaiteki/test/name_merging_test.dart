import "package:kaiteki/utils/name_merging.dart";
import "package:kaiteki_core/model.dart";
import "package:test/test.dart";

void main() {
  test("separated", () {
    const user = User(
      id: "",
      displayName: "Wonderful Alice",
      username: "alice",
      host: "example.org",
    );
    final content = mergeNameOfUser(user);
    expect(content, isNull);
  });

  test("unseparated", () {
    const user = User(
      id: "",
      displayName: "Alice",
      username: "alice",
      host: "example.org",
    );
    final content = mergeNameOfUser(user);
    expect(content, isNotNull);
    expect(content!.$1, equals("Alice"));
    expect(content.$2, equals("@example.org"));
  });
}
