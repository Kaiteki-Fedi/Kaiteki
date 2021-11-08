import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/ui/widgets/posts/avatar_widget.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class AccountSwitcherWidget extends StatefulWidget {
  final double? size;

  const AccountSwitcherWidget({Key? key, this.size}) : super(key: key);

  @override
  _AccountSwitcherWidgetState createState() => _AccountSwitcherWidgetState();
}

class _AccountSwitcherWidgetState extends State<AccountSwitcherWidget> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<String>(
      iconSize: widget.size,
      icon: buildIcon(context),
      onSelected: (choice) {
        assert(choice == "!");
        Navigator.of(context).pushNamed("/accounts");
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Mdi.dotsHorizontal),
              ),
              Text(l10n.manageAccountsTitle),
            ],
          ),
          value: "!",
        ),
      ],
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
      size: widget.size ?? 48,
    );
  }
}
