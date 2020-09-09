import 'package:flutter/material.dart';
import 'package:kaiteki/api/model/mastodon/account.dart';
import 'package:kaiteki/ui/screens/account_screen.dart';
import 'package:mdi/mdi.dart';

/// A tap-able avatar.
class AvatarWidget extends StatelessWidget {
  final MastodonAccount _account;
  final double size;
  final bool openOnTap;

  const AvatarWidget(this._account, {this.size, this.openOnTap = true});

  @override
  Widget build(BuildContext context) {
    if (!openOnTap)
      return _getAvatarImageWidget();

    return GestureDetector(
      child: _getAvatarImageWidget(),
      onTap: () {
        var screen = AccountScreen(_account.id);
        var route = MaterialPageRoute(builder: (_) => screen);
        Navigator.push(context, route);
      },
    );
  }

  Widget _getAvatarImageWidget() {
    if (_account == null)
      return Icon(
        Mdi.accountCircle,
        size: size,
      );

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        _account.avatar,
        height: size,
        width: size,
        isAntiAlias: true,
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}
