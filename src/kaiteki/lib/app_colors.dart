import 'package:flutter/material.dart';

class AppColors {
  static MaterialColor kaitekiLightBackground = const MaterialColor(
    0xFF9c9eb5,
    {
      50: Color(0xFFf7f9ff),
      100: Color(0xFFf2f4ff),
      200: Color(0xFFebedff),
      300: Color(0xFFdee0f8),
      400: Color(0xFFbbbdd5),
      500: Color(0xFF9c9eb5),
      600: Color(0xFF73758b),
      700: Color(0xFF5f6176),
      800: Color(0xFF404256),
      900: Color(0xFF1e2133),
    },
  );

  static MaterialColor kaitekiDarkBackground = const MaterialColor(
    0xFF1e2133,
    {
      50: Color(0xFF424453),
      100: Color(0xFF3F4251),
      200: Color(0xFF3D404F),
      300: Color(0xFF393B4B),
      400: Color(0xFF363949),
      500: Color(0xFF323545),
      600: Color(0xFF2F3243),
      700: Color(0xFF2D3041),
      800: Color(0xFF292C3D),
      900: Color(0xFF1e2133),
    },
  );

  static MaterialColor kaitekiPink = const MaterialColor(
    0xFFFF7890,
    {
      50: Color(0xFFffe7ec),
      100: Color(0xFFffc3cf),
      200: Color(0xFFff9daf),
      300: Color(0xFFff7890),
      400: Color(0xFFfc5f78),
      500: Color(0xFFfa4f62),
      600: Color(0xFFe94960),
      700: Color(0xFFd3425c),
      800: Color(0xFFbe3b59),
      900: Color(0xFF9a3052),
    },
  );

  static MaterialColor kaitekiOrange = const MaterialColor(
    0xFFFFB16C,
    {
      50: Color(0xFFfff2e4),
      100: Color(0xFFffddbc),
      200: Color(0xFFffc792),
      300: Color(0xFFfea054),
      400: Color(0xFFfea054),
      500: Color(0xFFfd9044),
      600: Color(0xFFf78642),
      700: Color(0xFFef773f),
      800: Color(0xFFe8683c),
      900: Color(0xFFdc5036),
    },
  );

  // picked from https://pleroma.social/
  static Color pleromaPrimary = const Color(0xFFF6A358);
  static Color pleromaSecondary = const Color(0xFF11181E);

  // picked from https://joinmastodon.org/
  static Color mastodonPrimary = const Color(0xFF4498DC);
  static Color mastodonSecondary = const Color(0xFF1F232B);

  // picked from https://misskey.io/preferences
  static Color misskeyPrimary = const Color(0xFF8DB600);
  static Color misskeySecondary = const Color(0xFF000000);
}
