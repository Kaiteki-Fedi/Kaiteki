import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/model/auth/account_compound.dart';
import 'package:kaiteki/ui/dialogs/dynamic_dialog_container.dart';
import 'package:kaiteki/ui/widgets/posts/avatar_widget.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class AccountListDialog extends StatelessWidget {
  const AccountListDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicDialogContainer(builder: (context, fullscreen) {
      final container = Provider.of<AccountManager>(context);
      final l10n = AppLocalizations.of(context)!;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            title: Text(l10n.manageAccountsTitle),
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            elevation: 0,
          ),
          Column(
            children: [
              for (final compound in container.accounts)
                AccountListTile(
                  compound: compound,
                  selected: container.currentAccount == compound,
                ),
              const Divider(),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).disabledColor,
                  foregroundColor: Colors.white,
                  child: const Icon(Mdi.plus),
                  radius: 22,
                ),
                title: Text(l10n.addAccountButtonLabel),
                onTap: () => onTapAdd(context),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ],
      );
    });
  }

  void onTapAdd(BuildContext context) {
    Navigator.of(context).pushNamed("/login");
  }
}

class AccountListTile extends StatelessWidget {
  final AccountCompound compound;
  final bool selected;

  const AccountListTile({
    Key? key,
    required this.compound,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      leading: AvatarWidget(
        compound.account,
        openOnTap: false,
        size: 44,
      ),
      title: Text(compound.accountSecret.username),
      subtitle: Text(compound.instance),
      onTap: () => _onSelect(context),
      trailing: IconButton(
        icon: const Icon(Mdi.close),
        onPressed: () => _onRemove(context),
        splashRadius: 24,
      ),
    );
  }

  void _onSelect(BuildContext context) async {
    final container = Provider.of<AccountManager>(context, listen: false);
    await container.changeAccount(compound);
  }

  void _onRemove(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AccountRemovalDialog(
          compound: compound,
        );
      },
    );
  }
}

class AccountRemovalDialog extends StatelessWidget {
  final AccountCompound compound;

  const AccountRemovalDialog({
    Key? key,
    required this.compound,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.accountRemovalConfirmationTitle),
      content: Text(l10n.accountRemovalConfirmationDescription),
      actions: <Widget>[
        TextButton(
          child: Text(l10n.cancelButtonLabel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(l10n.removeButtonLabel),
          onPressed: () {
            final container = Provider.of<AccountManager>(
              context,
              listen: false,
            );
            container.remove(compound);
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
