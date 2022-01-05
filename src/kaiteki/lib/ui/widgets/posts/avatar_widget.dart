import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/ui/screens/user_screen.dart';
import 'package:mdi/mdi.dart';

/// A tap-able avatar.
class AvatarWidget extends StatelessWidget {
  final User _user;
  final double size;
  final double? radius;
  final bool openOnTap;

  const AvatarWidget(
    this._user, {
    Key? key,
    this.size = 48,
    this.radius,
    this.openOnTap = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!openOnTap) return _getAvatarImageWidget(context);

    return GestureDetector(
      child: _getAvatarImageWidget(context),
      onTap: () {
        final screen = UserScreen.fromUser(_user);
        final route = MaterialPageRoute(builder: (_) => screen);
        Navigator.push(context, route);
      },
    );
  }

  Widget _getAvatarImageWidget(BuildContext context) {
    final size = this.size;

    if (_user.avatarUrl == null) {
      return Icon(
        Mdi.accountCircle,
        size: size,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
        ),
        child: Image.network(
          _user.avatarUrl!,
          width: size,
          height: size,
          errorBuilder: (context, _, __) => _buildFallback(context, size),
        ),
      ),
    );
  }

  Widget _buildFallback(context, size) {
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
  }
}
