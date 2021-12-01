class Constants {
  static const String appName = "Kaiteki";
  static const String appWebsite = "https://craftplacer.moe/projects/kaiteki";
  static const String githubRepository = "https://github.com/Kaiteki-Fedi/Kaiteki";
  static const String appDescription = "The comfy Fediverse client";
  static const String userAgent = "Kaiteki/1.0";

  static const String exampleAvatar =
      "https://craftplacer.keybase.pub/cute.jpg";

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

  static const double defaultSplashRadius = 24.0;
}
