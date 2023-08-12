import "package:flutter/painting.dart";
import "package:kaiteki_core/kaiteki_core.dart";

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

/// API theme for Twitter.
const tumblrTheme = ApiTheme(
  Color(0xFF00B8FF),
  "assets/icons/tumblr.png",
);

const foundKeyTheme = ApiTheme(
  Color(0xFF981a28),
  "assets/icons/foundkey.png",
);

const calckeyTheme = ApiTheme(
  Color(0xFF2d7590),
  "assets/icons/calckey.png",
);

extension ApiThemeExtension on ApiType {
  ApiTheme get theme {
    return switch (this) {
      ApiType.mastodon => mastodonTheme,
      ApiType.glitch => mastodonTheme,
      ApiType.misskey => misskeyTheme,
      ApiType.pleroma => pleromaTheme,
      ApiType.akkoma => akkomaTheme,
      ApiType.foundkey => foundKeyTheme,
      ApiType.calckey => calckeyTheme,
      ApiType.tumblr => tumblrTheme,
    };
  }
}
