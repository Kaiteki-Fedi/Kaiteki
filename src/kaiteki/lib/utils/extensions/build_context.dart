import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/ui/screens/post_screen.dart';

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
}
