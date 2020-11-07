import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/api/adapters/fediverse_adapter.dart';
import 'package:kaiteki/model/fediverse/post.dart';
import 'package:kaiteki/model/fediverse/user.dart';
import 'package:kaiteki/ui/widgets/status_widget.dart';
import 'package:kaiteki/utils/text_renderer.dart';
import 'package:kaiteki/utils/text_renderer_theme.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  final String id;

  AccountScreen(this.id);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var container = Provider.of<AccountContainer>(context);

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: container.adapter.getUserById(widget.id),
        builder: (_, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasError) {
            return Text("oops: " + snapshot.error.toString());
          }

          if (!snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          return ListView(
            children: [
              Material(
                child: AccountHeader(account: snapshot.data),
                elevation: 4,
              ),
              getStatusBody(container.adapter),
            ],
          );
        },
      ),
    );
  }

  Widget getStatusBody(FediverseAdapter adapter) {
    return FutureBuilder(
      future: adapter.getStatusesOfUserById(widget.id),
      builder: (BuildContext context, AsyncSnapshot<Iterable<Post>> snapshot) {
        if (snapshot.hasData) {
          var statuses = snapshot.data;

          return Column(
            children: [
              for (var status in statuses) StatusWidget(status),
            ],
          );
        } else if (snapshot.hasError) {
          return Text("oof: " + snapshot.error.toString());
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class AccountHeader extends StatelessWidget {
  const AccountHeader({
    Key key,
    @required this.account,
  }) : super(key: key);

  final User account;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(image: getDecorationBackground(account)),
      child: Column(
        children: [
          Row(
            children: [
              Image.network(account.avatarUrl, width: 56, height: 56),
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
                  theme: TextRendererTheme.fromContext(context),
                ).renderFromHtml(account.description)
              ],
              style: TextStyle(
                shadows: [Shadow(blurRadius: 2, offset: Offset(0, 1))],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DecorationImage getDecorationBackground(User account) {
    if (account.bannerUrl == null) return null;

    return DecorationImage(
      fit: BoxFit.cover,
      image: NetworkImage(account.bannerUrl),
    );
  }
}
