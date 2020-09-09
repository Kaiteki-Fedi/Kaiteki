import 'package:flutter/material.dart';
import 'package:kaiteki/model/account_compound.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/ui/widgets/avatar_widget.dart';
import 'package:kaiteki/ui/widgets/icon_landing_widget.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class ManageAccountsScreen extends StatefulWidget {
  ManageAccountsScreen({Key key}) : super(key: key);

  @override
  _ManageAccountsScreenState createState() => _ManageAccountsScreenState();
}

class _ManageAccountsScreenState extends State<ManageAccountsScreen> {
  @override
  Widget build(BuildContext context) {
    var container = Provider.of<AccountContainer>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Accounts"),
      ),
      body: FutureBuilder(
        future: container.getAvailableAccounts(),
        builder: (_, AsyncSnapshot<List<AccountCompound>> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          var length = snapshot.data.length;

          if (length == 0) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: IconLandingWidget(
                      icon: Mdi.accountOutline,
                      text: "No accounts"
                    ),
                  ),
                  OutlineButton.icon(
                    icon: Icon(Mdi.plus),
                    label: Text("Add Account"),
                    onPressed: () => onTapAdd(context),
                  )
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: length + 2,
            itemBuilder: (_, i) {
              if (i == length)
                return Divider();

              if (i == length + 1)
                return ListTile(
                  leading: Icon(Mdi.plus),
                  title: Text("Add Account"),
                  onTap: () => onTapAdd(context),
                );

              var compound = snapshot.data[i];
              return ListTile(
                selected: i == 0,
                leading: AvatarWidget(
                  compound.account,
                  openOnTap: false,
                ),
                title: Text(compound.accountSecret.username),
                subtitle: Text(compound.instance),
                onTap: () async => await container.changeAccount(compound),
                trailing: IconButton(
                  icon: Icon(Mdi.close),
                  onPressed: () => onTapRemove(context, container, compound),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void onTapAdd(BuildContext context) {
    Navigator.of(context).pushNamed("/accounts/add");
  }

  void onTapRemove(BuildContext context, AccountContainer container, AccountCompound account) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Are you sure you want to remove this account?"),
        content: const Text("You will have to add this account again later."),
        actions: <Widget>[
          FlatButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("REMOVE"),
            onPressed: () {
              container.remove(account);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}