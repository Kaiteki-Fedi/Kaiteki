import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/ui/screens/auth/login_screen.dart';
import 'package:kaiteki/ui/widgets/separator_text.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kaiteki/api/api_type.dart';
import 'package:kaiteki/app_colors.dart';

class InstanceListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var container = Provider.of<AccountContainer>(context);

    return ListView(
      padding: const EdgeInsets.only(top: 8.0),
      children: [
        ListTile(
          leading: Icon(Mdi.autoFix),
          title: Text("Automatic"),
          subtitle: Text("Kaiteki will try to determine which instance you're trying to add."),
          isThreeLine: true,
        ),
        Divider(),
        SeparatorText("Select Manually"),
        ListTile(
          leading: Image.asset(
            "assets/icons/mastodon.png",
            height: 24,
          ),
          title: Text("Mastodon"),
          enabled: false,
          onTap: () => Navigator.push(
            context,
            getRoute(
              LoginScreen(
                image: AssetImage("assets/icons/mastodon.png"),
                color: AppColors.mastodonPrimary,
                backgroundColor: AppColors.mastodonSecondary,
                onLogin: container.createAdapter(ApiType.Mastodon).login,
              )
            )
          ),
        ),
        ListTile(
          leading: Image.asset(
            "assets/icons/pleroma.png",
            height: 24,
          ),
          title: Text("Pleroma"),
          onTap: () => Navigator.push(
            context,
            getRoute(
              LoginScreen(
                image: AssetImage("assets/icons/pleroma.png"),
                color: AppColors.pleromaPrimary,
                backgroundColor: AppColors.pleromaSecondary,
                onLogin: container.createAdapter(ApiType.Pleroma).login,
              )
            )
          ),
        ),
        ListTile(
          leading: Image.asset(
            "assets/icons/misskey.png",
            height: 24,
          ),
          title: Text("Misskey"),
          onTap: () => Navigator.push(
              context,
              getRoute(
                  LoginScreen(
                    image: AssetImage("assets/icons/misskey.png"),
                    color: AppColors.misskeyPrimary,
                    backgroundColor: AppColors.misskeySecondary,
                    onLogin: container.createAdapter(ApiType.Misskey).login,
                  )
              )
          ),
        ),
        Divider(),
        SeparatorText("More"),
        ListTile(
          leading: Icon(Mdi.dotsHorizontal),
          title: Text("Not in this list"),
          subtitle: Text("Tap here to request support for a different backend."),
          onTap: () async {
            const String url = "https://github.com/Craftplacer/kaiteki/issues/new";

            if (await canLaunch(url))
              await launch(url);
            else {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                    content: Text("URL couldn't be opened.")
                ),
              );
            }
          },
        )
      ],
    );
  }

  PageRoute getRoute(LoginScreen screen) => PageRouteBuilder(
    pageBuilder: (_, __, ___) => screen,
    transitionsBuilder: (_, anime, anime2, child) => SharedAxisTransition(
      child: child,
      animation: anime,
      secondaryAnimation: anime2,
      transitionType: SharedAxisTransitionType.scaled,
    ),
  );
}
