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
    if (!openOnTap) return _getAvatarImageWidget();

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
    if (_user == null) {
      return Icon(
        Mdi.accountCircle,
        size: _getFixedSize(),
      );
    }

    return CircleAvatar(
      backgroundImage: NetworkImage(_user.avatarUrl),
      radius: _getFixedSize(half: true),
    );
  }

  double _getFixedSize({bool half}) {
    if (size == null || size == 0) return null;

    // this dumb bool condition is intentional for null safety.
    if (half == true)
      return size / 2;
    else
      return size;
  }
}
