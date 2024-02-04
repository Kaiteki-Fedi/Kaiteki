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
    this.angle = 0,
    this.flipHorizontally = false,
  });
}

final class AnimalEarAvatarDecoration extends AvatarDecoration {
  final AnimalEarAvatarDecorationType type;

  const AnimalEarAvatarDecoration(this.type);

  const AnimalEarAvatarDecoration.cat()
      : this(AnimalEarAvatarDecorationType.cat);
}

enum AnimalEarAvatarDecorationType { cat }
