import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/theming/default_app_themes.dart';

class AvatarWidget extends StatelessWidget {
  final User user;
  final double? size;
  final VoidCallback? onTap;
  final BorderRadius? radius;

  const AvatarWidget(
    this.user, {
    Key? key,
    this.size = 48,
    this.onTap,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = this.size;
    final url = user.avatarUrl;

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
        width: size,
        height: size,
        cacheWidth: size?.toInt(),
        cacheHeight: size?.toInt(),
        errorBuilder: (_, __, ___) => fallback,
      );
    }

    avatar = ColoredBox(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: avatar,
    );

    if (onTap != null) {
      avatar = InkWell(onTap: onTap, child: avatar);
    }

    // Add rounding
    // ignore: join_return_with_assignment
    avatar = radius == null
        ? ClipOval(child: avatar)
        : ClipRRect(borderRadius: borderRadius, child: avatar);

    return avatar;
  }
}

class FallbackAvatar extends StatelessWidget {
  const FallbackAvatar({
    Key? key,
  }) : super(key: key);

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
