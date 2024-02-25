import "package:flutter/material.dart";
import "package:flutter_blurhash/flutter_blurhash.dart";
import "package:kaiteki_core/model.dart";

class AvatarWidget extends StatelessWidget {
  final Uri? url;
  final String? blurHash;
  final double size;
  final VoidCallback? onTap;
  final ShapeBorder? shape;
  final FocusNode? focusNode;
  final UserType type;
  final List<AvatarDecoration> decorations;

  AvatarWidget(
    User? user, {
    super.key,
    this.size = 48,
    this.onTap,
    this.shape,
    this.focusNode,
  })  : url = user?.avatarUrl,
        blurHash = user?.avatarBlurHash,
        type = user?.type ?? UserType.person,
        decorations = user?.avatarDecorations ?? const [];

  const AvatarWidget.url(
    this.url, {
    this.blurHash,
    super.key,
    this.size = 48,
    this.onTap,
    this.shape,
    this.focusNode,
    this.type = UserType.person,
    this.decorations = const [],
  });

  @override
  Widget build(BuildContext context) {
    final fallback = SizedBox(
      width: size,
      height: size,
      child: FallbackAvatar(
        icon: switch (type) {
          UserType.bot => const Icon(Icons.smart_toy_rounded),
          UserType.group => const Icon(Icons.groups_rounded),
          UserType.organization => const Icon(Icons.pages_rounded),
          UserType.person => const Icon(Icons.person_rounded),
        },
      ),
    );

    final url = this.url;
    var avatar = url == null
        ? fallback
        : Image.network(
            url.toString(),
            frameBuilder: _getFrameBuilder(fallback),
            width: size,
            height: size,
            errorBuilder: (_, __, ___) => fallback,
            fit: BoxFit.cover,
          );

    if (onTap != null) {
      avatar = InkWell(onTap: onTap, focusNode: focusNode, child: avatar);
    }

    final theme = Theme.of(context);
    final shape = this.shape ??
        theme.extension<AvatarTheme>()?.shape ??
        const CircleBorder();

    avatar = Material(
      clipBehavior: Clip.antiAlias,
      shape: shape,
      color: theme.colorScheme.surfaceVariant,
      child: IconTheme.merge(
        data: IconThemeData(
          color: theme.colorScheme.onSurface,
        ),
        child: avatar,
      ),
    );

    // only show the decoration if the avatar is big enough, otherwise it's
    // too small to be distinguishable
    if (decorations.isNotEmpty && size > 24) {
      final decorationOffset = (size / 2) * -1;
      avatar = Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          for (final decoration in decorations)
            Positioned.fill(
              top: decorationOffset,
              left: decorationOffset,
              right: decorationOffset,
              bottom: decorationOffset,
              child: IgnorePointer(
                child: _buildDecoration(decoration),
              ),
            ),
        ],
      );
    }

    return avatar;
  }

  Widget? _buildDecoration(AvatarDecoration decoration) {
    return switch (decoration) {
      OverlayAvatarDecoration() => IgnorePointer(
          child: Transform.rotate(
            angle: decoration.angle,
            child: Image.network(
              decoration.url.toString(),
            ),
          ),
        ),
      AnimalEarAvatarDecoration() => null,
    };
  }

  ImageFrameBuilder _getFrameBuilder(Widget? fallback) {
    return (context, child, frame, wasSynchronouslyLoaded) {
      if (wasSynchronouslyLoaded) return child;

      Widget getChild() {
        final blurHash = this.blurHash;

        if (frame != null) return child;

        if (blurHash != null) {
          return SizedBox.square(
            dimension: size,
            child: BlurHash(
              hash: blurHash,
              color: Colors.transparent,
            ),
          );
        }

        return fallback ?? child;
      }

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: getChild(),
      );
    };
  }
}


class FallbackAvatar extends StatelessWidget {
  final Widget? icon;

  const FallbackAvatar({
    super.key,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxHeight;
        final padding = size / 6;

        return Padding(
          padding: EdgeInsets.all(padding),
          child: IconTheme.merge(
            data: IconThemeData(
              size: size - (padding * 2),
            ),
            child: icon ?? const Icon(Icons.person_rounded),
          ),
        );
      },
    );
  }
}

class AvatarTheme extends ThemeExtension<AvatarTheme> {
  final ShapeBorder? shape;

  const AvatarTheme({this.shape});

  @override
  AvatarTheme copyWith({ShapeBorder? shape}) {
    return AvatarTheme(
      shape: shape ?? this.shape,
    );
  }

  @override
  AvatarTheme lerp(covariant AvatarTheme? other, double t) {
    return AvatarTheme(
      shape: ShapeBorder.lerp(shape, other?.shape, t),
    );
  }
}
