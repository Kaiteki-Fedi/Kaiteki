import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/app_colors.dart';
import 'package:kaiteki/ui/screens/login_screen.dart';

class AddAccountScreen extends StatefulWidget {
  AddAccountScreen({Key key}) : super(key: key);

  @override
  _AddAccountScreenState createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Account")
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Image.asset(
              "assets/icons/mastodon.png",
              height: 24,
            ),
            title: Text("Mastodon"),
            onTap: () => Navigator.push(
                context,
                getRoute(
                    LoginScreen(
                      image: AssetImage("assets/icons/mastodon.png"),
                      color: AppColors.mastodonPrimary,
                      backgroundColor: AppColors.mastodonSecondary,
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
            subtitle: Text("Soon™"),
            onTap: () => Navigator.push(
                context,
                getRoute(
                    LoginScreen(
                      image: AssetImage("assets/icons/misskey.png"),
                      color: AppColors.misskeyPrimary,
                      backgroundColor: AppColors.misskeySecondary,
                    )
                )
            ),
          ),
        ],
      )
    );
  }

  PageRoute getRoute(LoginScreen screen) => PageRouteBuilder(
    pageBuilder: (_, __, ___) => screen,
    transitionsBuilder: (_, anime, anime2, child) => SharedAxisTransition(
      child: child,
      animation: anime,
      secondaryAnimation: anime2,
      transitionType: SharedAxisTransitionType.horizontal,
    ),
  );


}