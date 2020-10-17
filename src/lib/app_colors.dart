import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class AppColors {
  static final Color darkBackground = const Color(0xFF1E2133);
  static final Color darkSurface = const Color(0xFF404256);

  static final Color lightBackground = const Color(0xFFebedff);
  static final Color lightSurface = const Color(0xFFf7f9ff);

  static MaterialColor kaitekiPink = MaterialColor(
    0xFFfa4f62,
    {
      50: const Color(0xFFffe7ec),
      100: const Color(0xFFffc3cf),
      200: const Color(0xFFff9daf),
      300: const Color(0xFFff7890),
      400: const Color(0xFFfc5f78),
      500: const Color(0xFFfa4f62),
      600: const Color(0xFFe94960),
      700: const Color(0xFFd3425c),
      800: const Color(0xFFbe3b59),
      900: const Color(0xFF9a3052),
    }
  );

  // picked from https://pleroma.social/
  static Color pleromaPrimary = Color(0xFFF6A358);
  static Color pleromaSecondary = Color(0xFF11181E);

  // picked from https://joinmastodon.org/
  static Color mastodonPrimary = Color(0xFF4498DC);
  static Color mastodonSecondary = Color(0xFF1F232B);

  // picked from https://misskey.io/preferences
  static Color misskeyPrimary = Color(0xFF8DB600);
  static Color misskeySecondary = Color(0xFF000000);
}