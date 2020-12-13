import 'package:flutter/painting.dart';
import 'package:kaiteki/api/api_type.dart';
import 'package:kaiteki/app_colors.dart';
import 'package:kaiteki/app_preferences.dart';

class Constants {
  static const String appName = "Kaiteki";
  static const String appWebsite = "https://github.com/Craftplacer/Kaiteki";
  static const String appDescription = appTagline;
  static const String appTagline = "the cute fediverse client";
  static const String userAgent = "Kaiteki/1.0";

  static const String exampleAvatar = "https://craftplacer.keybase.pub/cute.jpg";

  /// the amount of dp/px until the application redefines the layout for
  /// desktop view.
  static const int desktopThreshold = 800;
  static const double defaultFormWidth = 448;
  static const double defaultFormHeight = 592;

  static String getPreferredAppName(NameMode mode) {
    switch (mode) {
      case NameMode.Hiragana: return "かいてき";
      case NameMode.Katakana: return "カイテキ";
      case NameMode.Kanji: return "快適";

      case NameMode.Romaji:
      default:
        return "Kaiteki";
    }
  }

  static const List<String> defaultScopes = [
    "read",
    "write",
    "follow",
    "push",
    "admin",
  ];

  static const List<String> defaultMisskeyPermissions = [
    "read:account",
    "write:account",
    "read:pages",
    "read:notifications",
    "write:notifications",
    "read:favorites",
    "write:favorites",
  ];

  // TODO: (quality) make a better data structure to represent different backends.
  static List<LoginOption> loginOptions = [
    LoginOption(
      "assets/icons/mastodon.png",
      AppColors.mastodonSecondary,
      AppColors.mastodonPrimary,
      ApiType.Mastodon,
      "Mastodon",
    ),
    LoginOption(
      "assets/icons/pleroma.png",
      AppColors.pleromaSecondary,
      AppColors.pleromaPrimary,
      ApiType.Pleroma,
      "Pleroma",
    ),
    LoginOption(
      "assets/icons/misskey.png",
      AppColors.misskeySecondary,
      AppColors.misskeyPrimary,
      ApiType.Misskey,
      "Misskey",
    ),
  ];
}

class LoginOption {
  final String iconAssetPath;
  final Color background;
  final Color foreground;
  final ApiType apiType;
  final String label;

  LoginOption(
    this.iconAssetPath,
    this.background,
    this.foreground,
    this.apiType,
    this.label,
  );
}
