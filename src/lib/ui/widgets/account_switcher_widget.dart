import 'package:flutter/material.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/ui/screens/manage_accounts_screen.dart';
import 'package:kaiteki/ui/widgets/avatar_widget.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class AccountSwitcherWidget extends StatefulWidget {
  const AccountSwitcherWidget({Key key}) : super(key: key);

  @override
  _AccountSwitcherWidgetState createState() => _AccountSwitcherWidgetState();
}

class _AccountSwitcherWidgetState extends State<AccountSwitcherWidget> {
  @override
  Widget build(BuildContext context) {
    var container = Provider.of<AccountContainer>(context);

    return PopupMenuButton<String>(
      icon: container.loggedIn
          ? AvatarWidget(container.currentAccount.account, openOnTap: false)
          : Icon(Mdi.accountCircle),
      onSelected: (choice) {
        assert(choice == "!");
        Navigator.push(context, MaterialPageRoute(builder: (_) => ManageAccountsScreen()));
      },

      itemBuilder: (_) => [
        PopupMenuItem(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(Mdi.dotsHorizontal),
                ),
                Text("Manage Accounts"),
              ],
            ),

            value: "!"
        )
      ],
    );
  }
}