import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/ui/shared/dialogs/account_list_dialog.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';

class AccountSwitcherWidget extends ConsumerWidget {
  final double? size;

  const AccountSwitcherWidget({Key? key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      iconSize: size ?? 24,
      icon: buildIcon(context, ref),
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

  Widget buildIcon(BuildContext context, WidgetRef ref) {
    final container = ref.watch(accountProvider);

    if (!container.loggedIn) {
      return const Icon(Icons.account_circle_rounded);
    }

    return AvatarWidget(
      container.currentAccount.user,
      size: size ?? 24,
    );
  }
}
