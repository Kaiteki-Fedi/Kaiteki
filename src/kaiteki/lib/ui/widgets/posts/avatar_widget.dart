import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/theming/app_themes/default_app_themes.dart';
import 'package:mdi/mdi.dart';

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
    var widget = buildAvatar(context);

    if (onTap != null) {
      widget = InkWell(onTap: onTap, child: widget);
    }

    return widget;
  }

  Widget buildAvatar(BuildContext context) {
    final size = this.size;
    final url = user.avatarUrl;

    final Widget avatar;

    if (url == null) {
      avatar = const FallbackAvatar();
    } else {
      avatar = ColoredBox(
        color: Theme.of(context).cardColor,
        child: Image.network(
          url,
          width: size,
          height: size,
          cacheWidth: size?.toInt(),
          cacheHeight: size?.toInt(),
          errorBuilder: (context, error, stackTrace) {
            return const FallbackAvatar();
          },
        ),
      );
    }

    if (radius == null) {
      return ClipOval(child: avatar);
    } else {
      return ClipRRect(borderRadius: borderRadius, child: avatar);
    }
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
        final theme = Theme.of(context);

        return Container(
          color: theme.disabledColor,
          padding: EdgeInsets.all(padding),
          child: Icon(
            Mdi.account,
            size: size - (padding * 2),
          ),
        );
      },
    );
  }
}
