import 'package:flutter/material.dart';
import 'package:kaiteki/model/fediverse/user.dart';
import 'package:kaiteki/ui/screens/account_screen.dart';
import 'package:mdi/mdi.dart';

/// A tap-able avatar.
class AvatarWidget extends StatelessWidget {
  final User _user;
  final double size;
  final bool openOnTap;

  const AvatarWidget(this._user, {this.size, this.openOnTap = true});

  @override
  Widget build(BuildContext context) {
    if (!openOnTap)
      return _getAvatarImageWidget();

    return GestureDetector(
      child: _getAvatarImageWidget(),
      onTap: () {
        var screen = AccountScreen(_user.id);
        var route = MaterialPageRoute(builder: (_) => screen);
        Navigator.push(context, route);
      },
    );
  }

  Widget _getAvatarImageWidget() {
    if (_user == null)
      return Icon(
        Mdi.accountCircle,
        size: size,
      );

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        _user.avatarUrl,
        height: size,
        width: size,
        isAntiAlias: true,
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}
