import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:kaiteki/fediverse/model/user/user.dart';
import 'package:kaiteki/utils/extensions.dart';

class AvatarWidget extends StatelessWidget {
  final User user;
  final double? size;
  final VoidCallback? onTap;
  final BorderRadius? radius;

  const AvatarWidget(
    this.user, {
    super.key,
    this.size = 48,
    this.onTap,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final size = this.size;
    final url = user.avatarUrl;
    final String? avatarBlurhash = user.source?.avatarBlurhash;

    Widget avatar;
    final Widget fallback = SizedBox(
      width: size,
      height: size,
      child: const FallbackAvatar(),
    );

    if (url == null) {
      avatar = fallback;
    } else {
      avatar = Image.network(
        url,
        loadingBuilder: avatarBlurhash?.nullTransform((b) => blurhashLoader),
        frameBuilder: avatarBlurhash?.nullTransform((b) => blurhashAnimation),
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }

    if (onTap != null) {
      avatar = InkWell(onTap: onTap, child: avatar);
    }

    final borderRadius = radius;
    // ignore: join_return_with_assignment
    avatar = Material(
      clipBehavior: Clip.antiAlias,
      shape: borderRadius == null
          ? const CircleBorder()
          : RoundedRectangleBorder(borderRadius: borderRadius),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: avatar,
    );

    return avatar;
  }

  Widget blurhashAnimation(context, child, frame, wasSynchronouslyLoaded) {
    if (wasSynchronouslyLoaded) {
      return child;
    }
    return AnimatedOpacity(
      opacity: frame == null ? 0 : 1,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
      child: child,
    );
  }

  Widget blurhashLoader(context, child, loadingProgress) {
    if (loadingProgress == null) {
      return child;
    }
    return SizedBox(
      width: size,
      height: size,
      child: BlurHash(hash: user.source.avatarBlurhash),
    );
  }
}

class FallbackAvatar extends StatelessWidget {
  const FallbackAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxHeight;
        final padding = size / 6;

        return Padding(
          padding: EdgeInsets.all(padding),
          child: Icon(
            Icons.person_rounded,
            size: size - (padding * 2),
          ),
        );
      },
    );
  }
}
