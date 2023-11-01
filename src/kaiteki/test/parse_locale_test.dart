import "dart:ui" show Locale;

import "package:kaiteki/utils/extensions.dart";
import "package:test/test.dart";

void main() {
  test("parse locale, 1 value", () {
    final locale = parseLocale("en");
    expect(locale, const Locale("en"));
  });

  test("parse locale, 2 value", () {
    final locale = parseLocale("en-US");
    expect(locale, const Locale("en", "US"));
  });

  test("parse locale, 3 value", () {
    final locale = parseLocale("zh-Hant-CN");
    expect(
      locale,
      const Locale.fromSubtags(
        languageCode: "zh",
        scriptCode: "Hant",
        countryCode: "CN",
      ),
    );
  });
}
