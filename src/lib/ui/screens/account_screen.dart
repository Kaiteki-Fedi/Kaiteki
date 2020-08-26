import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kaiteki/utils/text_renderer.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/api/clients/mastodon_client.dart';
import 'package:kaiteki/api/clients/pleroma_client.dart';
import 'package:kaiteki/api/model/mastodon/account.dart';
import 'package:kaiteki/api/model/mastodon/status.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:kaiteki/ui/widgets/status_widget.dart';
import 'package:provider/provider.dart';


class AccountScreen extends StatelessWidget {

  final String id;

  AccountScreen(this.id);

  @override
  Widget build(BuildContext context) {
    var container = Provider.of<AccountContainer>(context);
    var pleroma = container.client as PleromaClient;

    var theme = Provider.of<ThemeContainer>(context);
    var pleromaTheme = theme.getCurrentPleromaTheme();
    var linkColor = pleromaTheme?.getColor("link")
        ?? Theme.of(context).accentColor;

    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (_, c) {
          var desktopMode = Constants.desktopThreshold <= c.maxWidth;
          if (desktopMode) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 256,
                    child: getAccountHeader(pleroma),
                  ),
                  SizedBox(width: 16),
                  Flexible(
                    child: SingleChildScrollView(
                      child: getStatusBody(pleroma),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            children: [
              Material(
                child: getAccountHeader(pleroma),
                elevation: 4,
              ),
              getStatusBody(pleroma),
            ]
          );
        },
      )
    );
  }

  Widget getAccountHeader(MastodonClient client) {
    return FutureBuilder(
      future: client.getAccount(id),
      builder: (_, AsyncSnapshot<MastodonAccount> snapshot) {
        if (snapshot.hasError) {
          return Text("oops: " + snapshot.error.toString());
        }

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return AccountHeader(
          account: snapshot.data
        );
      },
    );
  }

  Widget getStatusBody(MastodonClient client) {
    return FutureBuilder(
      future: client.getStatuses(id),
      builder: (BuildContext context, AsyncSnapshot<Iterable<MastodonStatus>> snapshot) {
        if (snapshot.hasData) {
          var statuses = snapshot.data;

          return Column(
            children: [
              for (var status in statuses)
                StatusWidget(status),
            ],
          );
        } else if (snapshot.hasError) {
          return Text("oof: " + snapshot.error.toString());
        } else{
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class AccountHeader extends StatelessWidget {
  const AccountHeader({
    Key key,
    @required this.account,
    @required this.linkColor,
  }) : super(key: key);

  final MastodonAccount account;
  final Color linkColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(account.header)
          )
        ),
        child: Column(
          children: [
            Row(
              children: [
                Image.network(
                  account.avatar,
                  width: 56,
                  height: 56
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(account.displayName),
                      Text('@' + account.username),
                    ],
                  ),
                )
              ],
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextRenderer(
                    emojis: account.emojis,
                    linkTextStyle: TextStyle(
                      color: linkColor
                    ),
                    textStyle: TextStyle(),
                  ).render(account.note)
                ],
                style: TextStyle(
                  shadows: [
                    Shadow(
                      blurRadius: 2,
                      offset: Offset(0, 1)
                    )
                  ]
                )
              )
            )
          ],
        )
    );
  }
}
