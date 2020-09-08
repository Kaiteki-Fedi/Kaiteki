import 'package:kaiteki/app_preferences.dart';

class Constants {
  static const String appName = "Kaiteki";
  static const String appWebsite = "https://github.com/Craftplacer/Kaiteki";
  static const String appDescription = appTagline;
  static const String appTagline = "the cute fediverse client";

  /// the amount of pixels until the application redefines the layout for
  /// desktop view.
  static const int desktopThreshold = 800;

  static String getPreferredAppName(NameMode mode) {
    switch (mode) {
      case NameMode.Romaji: return "Kaiteki";
      case NameMode.Hiragana: return "かいてき";
      case NameMode.Katakana: return "カイテキ";
      case NameMode.Kanji: return "快適";
      default: throw "Out of range";
    }
  }

  static const List<String> defaultScopes = [
    "read",
    "write",
    "follow",
    "push",
    "admin"
  ];
}