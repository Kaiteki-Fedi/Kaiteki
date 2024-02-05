import "package:flutter/painting.dart";
import "package:kaiteki_core_backends/kaiteki_core_backends.dart";

class ApiTheme {
  final Color accent;
  final String? iconAssetLocation;

  const ApiTheme(
    this.accent,
    this.iconAssetLocation,
  );
}

const mastodonTheme = ApiTheme(
  Color(0xFF6364FF),
  "assets/icons/mastodon.png",
);

const misskeyTheme = ApiTheme(
  Color(0xFF8DB600),
  "assets/icons/misskey.png",
);

const pleromaTheme = ApiTheme(
  Color(0xFFF6A358),
  "assets/icons/pleroma.png",
);

const akkomaTheme = ApiTheme(
  Color(0xFF462D7A),
  "assets/icons/akkoma.png",
);

const foundKeyTheme = ApiTheme(
  Color(0xFF981a28),
  "assets/icons/foundkey.png",
);

const calckeyTheme = ApiTheme(
  Color(0xFF2d7590),
  "assets/icons/calckey.png",
);

extension ApiThemeExtension on BackendType {
  ApiTheme get theme {
    return switch (this) {
      BackendType.mastodon => mastodonTheme,
      BackendType.glitch => mastodonTheme,
      BackendType.misskey => misskeyTheme,
      BackendType.pleroma => pleromaTheme,
      BackendType.akkoma => akkomaTheme,
      BackendType.foundkey => foundKeyTheme,
      BackendType.calckey => calckeyTheme
    };
  }
}
