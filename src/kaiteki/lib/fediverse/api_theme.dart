import 'package:flutter/painting.dart';

class ApiTheme {
  final Color backgroundColor;
  final Color primaryColor;
  final String? iconAssetLocation;

  const ApiTheme(
    this.backgroundColor,
    this.primaryColor, {
    this.iconAssetLocation,
  });
}

/// API theme for Mastodon. Colors picked from https://joinmastodon.org/.
const mastodonTheme = ApiTheme(
  Color(0xFF1F232B),
  Color(0xFF4498DC),
  iconAssetLocation: 'assets/icons/mastodon.png',
);

/// API theme for Misskey. Colors picked from https://misskey.io/preferences.
const misskeyTheme = ApiTheme(
  Color(0xFF000000),
  Color(0xFF8DB600),
  iconAssetLocation: 'assets/icons/misskey.png',
);

/// API theme for Pleroma. Colors picked from https://pleroma.social/.
const pleromaTheme = ApiTheme(
  Color(0xFF11181E),
  Color(0xFFF6A358),
  iconAssetLocation: 'assets/icons/pleroma.png',
);
