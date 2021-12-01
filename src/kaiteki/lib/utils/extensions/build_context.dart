import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/ui/screens/post_screen.dart';
import 'package:url_launcher/url_launcher.dart';

extension BuildContextExtensions on BuildContext {
  Future<void> showPostDialog({Post? replyTo}) async {
    final key = GlobalKey();
    await showDialog(
      context: this,
      builder: (context) => PostScreen(
        key: key,
        replyTo: replyTo,
      ),
      barrierDismissible: true,
    );
  }

  Future<bool> launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
      return true;
    } else {
      final messenger = ScaffoldMessenger.of(this);
      final l10n = AppLocalizations.of(this)!;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.failedToLaunchUrl)),
      );
      return false;
    }
  }
}
