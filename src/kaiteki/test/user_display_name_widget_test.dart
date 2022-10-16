import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/ui/shared/posts/user_display_name_widget.dart';
import 'package:test/test.dart';

void main() {
  test("separated with secondary", () {
    const user = User(
      id: "",
      source: null,
      username: "alice",
      displayName: "Alice 🌈",
      host: "example.org",
    );

    final content = DisplayNameTuple.fromUser(user);
    expect(content.secondary, equals("alice@example.org"));
    expect(content.separate, isTrue);
  });

  test("unseparated with secondary", () {
    const user = User(
      id: "",
      source: null,
      username: "alice",
      displayName: "Alice",
      host: "example.org",
    );

    final content = DisplayNameTuple.fromUser(user);
    expect(content.secondary, equals("@example.org"));
    expect(content.separate, isFalse);
  });

  test("unseparated without secondary", () {
    const user = User(
      id: "",
      source: null,
      username: "alice",
      displayName: "Alice",
      host: "example.org",
    );

    final content = DisplayNameTuple.fromUser(user);
    expect(content.secondary, isNull);
    expect(content.separate, isFalse);
  });
}
