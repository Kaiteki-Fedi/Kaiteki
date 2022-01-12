import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/ui/screens/compose_screen.dart';
import 'package:kaiteki/ui/screens/user_screen.dart';
import 'package:url_launcher/url_launcher.dart';

extension BuildContextExtensions on BuildContext {
  Future<void> showPostDialog({Post? replyTo}) async {
    final key = GlobalKey();
    await showDialog(
      context: this,
      builder: (context) => ComposeScreen(
        key: key,
        replyTo: replyTo,
      ),
      barrierDismissible: true,
    );
  }

  Future<void> showUser(User user) async {
    final route = MaterialPageRoute(builder: (_) => UserScreen.fromUser(user));
    final navigator = Navigator.of(this);
    await navigator.push(route);
  }

  Future<bool> launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
      return true;
    } else {
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(content: Text(getL10n().failedToLaunchUrl)),
      );
      return false;
    }
  }
}
