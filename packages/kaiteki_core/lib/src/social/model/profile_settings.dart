class ProfileSettings {
  /// The raw description of the profile. If null, it will be assumed that the
  /// instance does not support editing descriptions.
  final String? description;

  /// URL of the avatar stored on the server.
  ///
  /// Will not be sent back to the server.
  final Uri? avatarUrl;

  /// URL of the background stored on the server.
  ///
  /// Will not be sent back to the server.
  final Uri? backgroundUrl;

  /// URL of the banner stored on the server.
  ///
  /// Will not be sent back to the server.
  final Uri? bannerUrl;

  final DateTime? birthday;

  /// Display name of the profile.
  ///
  /// Empty strings are not permitted, they should be null instead.
  final String? displayName;

  final List<MapEntry<String, String>>? fields;

  const ProfileSettings({
    required this.description,
    this.avatarUrl,
    this.backgroundUrl,
    this.bannerUrl,
    this.birthday,
    this.displayName,
    this.fields = const [],
  });
}
