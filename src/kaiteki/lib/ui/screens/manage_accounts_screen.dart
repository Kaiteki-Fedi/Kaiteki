import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final container = Provider.of<AccountManager>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.manageAccountsTitle)),
      body: Builder(
        builder: (_) {
          var length = container.accounts.length;

          if (length == 0) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: IconLandingWidget(
                      icon: const Icon(Mdi.accountOutline),
                      text: Text(l10n.emptyAccounts),
                    ),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Mdi.plus),
                    label: Text(l10n.addAccountButtonLabel),
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
                  title: Text(l10n.addAccountButtonLabel),
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
    Navigator.of(context).pushNamed("/login");
  }

  void onTapRemove(
    BuildContext context,
    AccountManager container,
    AccountCompound account,
  ) {
    final l10n = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.accountRemovalConfirmationTitle),
        content: Text(l10n.accountRemovalConfirmationDescription),
        actions: <Widget>[
          TextButton(
            child: Text(l10n.cancelButtonLabel),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(l10n.removeButtonLabel),
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
