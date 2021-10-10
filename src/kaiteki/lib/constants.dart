class Constants {
  static const String appName = "Kaiteki";
  static const String appWebsite = "https://github.com/Craftplacer/Kaiteki";
  static const String appDescription = "Cross-platform Fediverse client";
  static const String userAgent = "Kaiteki/1.0";

  static const String exampleAvatar =
      "https://craftplacer.keybase.pub/cute.jpg";

  /// the amount of dp/px until the application redefines the layout for
  /// desktop view.
  static const int desktopThreshold = 800;
  static const double defaultFormWidth = 448;
  static const double defaultFormHeight = 592;

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
}
