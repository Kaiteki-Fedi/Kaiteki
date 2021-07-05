import 'package:flutter/material.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/model/auth/account_compound.dart';
import 'package:kaiteki/ui/widgets/icon_landing_widget.dart';
import 'package:kaiteki/ui/widgets/posts/avatar_widget.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class ManageAccountsScreen extends StatefulWidget {
  const ManageAccountsScreen({Key? key}) : super(key: key);

  @override
  _ManageAccountsScreenState createState() => _ManageAccountsScreenState();
}

class _ManageAccountsScreenState extends State<ManageAccountsScreen> {
  @override
  Widget build(BuildContext context) {
    var container = Provider.of<AccountManager>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Accounts")),
      body: Builder(
        builder: (_) {
          var length = container.accounts.length;

          if (length == 0) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: IconLandingWidget(
                      Mdi.accountOutline,
                      'No accounts',
                    ),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Mdi.plus),
                    label: const Text("Add Account"),
                    onPressed: () => onTapAdd(context),
                  )
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: length + 2,
            itemBuilder: (_, i) {
              if (i == length) return const Divider();

              if (i == length + 1) {
                return ListTile(
                  leading: const Icon(Mdi.plus),
                  title: const Text("Add Account"),
                  onTap: () => onTapAdd(context),
                );
              }

              var compound = container.accounts.elementAt(i);
              return ListTile(
                selected: container.currentAccount == compound,
                leading: AvatarWidget(
                  compound.account,
                  openOnTap: false,
                ),
                title: Text(compound.accountSecret.username),
                subtitle: Text(compound.instance),
                onTap: () async => await container.changeAccount(compound),
                trailing: IconButton(
                  icon: const Icon(Mdi.close),
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

  void onTapRemove(
    BuildContext context,
    AccountManager container,
    AccountCompound account,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure you want to remove this account?"),
        content: const Text("You will have to add this account again later."),
        actions: <Widget>[
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("REMOVE"),
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
