import 'package:flutter/material.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/ui/dialogs/account_list_dialog.dart';
import 'package:kaiteki/ui/widgets/posts/avatar_widget.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class AccountSwitcherWidget extends StatelessWidget {
  final double? size;

  const AccountSwitcherWidget({Key? key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: size ?? 24,
      icon: buildIcon(context),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return const AccountListDialog();
          },
        );
      },
    );
  }

  Widget buildIcon(BuildContext context) {
    var container = Provider.of<AccountManager>(context);

    if (!container.loggedIn) {
      return const Icon(Mdi.accountCircle);
    }

    return AvatarWidget(
      container.currentAccount.account,
      openOnTap: false,
      size: size ?? 24,
    );
  }
}
