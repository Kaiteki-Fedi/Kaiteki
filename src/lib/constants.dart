class Constants {
  static const String appName = "Kaiteki";
  static const String appWebsite = "https://github.com/Craftplacer/Kaiteki";
  static const String appDescription = appTagline;
  static const String appTagline = "the cute fediverse client";

  /// the amount of pixels until the application redefines the layout for
  /// desktop view.
  static const int desktopThreshold = 800;

  static const List<String> defaultScopes = [
    "read",
    "write",
    "follow",
    "push",
    "admin"
  ];
}