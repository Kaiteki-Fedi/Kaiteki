import "package:kaiteki/utils/utils.dart";
import "package:test/test.dart";

void main() {
  test("no at", () {
    expect(
      parseUserHandle("username"),
      equals(null),
    );
  });

  test("leading at, only username", () {
    expect(
      parseUserHandle("@username"),
      equals(("username", null)),
    );
  });

  test("leading at, username and host", () {
    expect(
      parseUserHandle("@username@host"),
      equals(("username", "host")),
    );
  });

  test("leading at, username and host, enforcing host", () {
    expect(
      parseUserHandle<String>("@username@host"),
      equals(("username", "host")),
    );
  });

  test("leading at, only username, enforcing host", () {
    expect(
      parseUserHandle<String>("@username"),
      equals(null),
    );
  });

  test("multiple at", () {
    expect(
      parseUserHandle<String>("@username@host@xyz"),
      equals(null),
    );
  });
}
