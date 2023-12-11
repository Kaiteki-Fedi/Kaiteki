/// A decoration for an avatar.
sealed class AvatarDecoration {
  const AvatarDecoration();
}

/// A decoration for an avatar that is a remote image.
final class OverlayAvatarDecoration extends AvatarDecoration {
  final String id;
  final Uri url;
  final double angle;
  final bool flipHorizontally;

  const OverlayAvatarDecoration({
    required this.id,
    required this.url,
    required this.angle,
    required this.flipHorizontally,
  });
}

final class AnimalEarAvatarDecoration extends AvatarDecoration {
  final AnimalEarAvatarDecorationType type;

  const AnimalEarAvatarDecoration(this.type);
}

enum AnimalEarAvatarDecorationType { cat }
