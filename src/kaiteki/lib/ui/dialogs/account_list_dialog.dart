import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/model/auth/account_compound.dart';
import 'package:kaiteki/ui/dialogs/dynamic_dialog_container.dart';
import 'package:kaiteki/ui/widgets/posts/avatar_widget.dart';
import 'package:mdi/mdi.dart';

class AccountListDialog extends ConsumerWidget {
  const AccountListDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DynamicDialogContainer(
      builder: (context, fullscreen) {
        final manager = ref.watch(accountProvider);
        final l10n = context.getL10n();

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
                for (final compound in manager.accounts)
                  AccountListTile(
                    compound: compound,
                    selected: manager.currentAccount == compound,
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
      },
    );
  }

  void onTapAdd(BuildContext context) {
    Navigator.of(context).pushNamed("/login");
  }
}

class AccountListTile extends ConsumerWidget {
  final AccountCompound compound;
  final bool selected;

  const AccountListTile({
    Key? key,
    required this.compound,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      selected: selected,
      leading: AvatarWidget(
        compound.account,
        openOnTap: false,
        size: 44,
      ),
      title: Text(compound.accountSecret.username),
      subtitle: Text(compound.instance),
      onTap: () => _onSelect(ref),
      trailing: IconButton(
        icon: const Icon(Mdi.close),
        onPressed: () => _onRemove(context),
        splashRadius: 24,
      ),
    );
  }

  Future<void> _onSelect(WidgetRef ref) async {
    await ref.read(accountProvider).changeAccount(compound);
  }

  Future<void> _onRemove(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AccountRemovalDialog(compound: compound),
    );
  }
}

class AccountRemovalDialog extends ConsumerWidget {
  final AccountCompound compound;

  const AccountRemovalDialog({
    Key? key,
    required this.compound,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.getL10n();

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
            ref.read(accountProvider).remove(compound);
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
