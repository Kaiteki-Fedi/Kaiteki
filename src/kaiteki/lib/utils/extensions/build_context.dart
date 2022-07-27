import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/ui/auth/login/api_web_compatibility_dialog.dart';
import 'package:kaiteki/ui/shared/compose_screen.dart';
import 'package:kaiteki/ui/shared/dialogs/exception_dialog.dart';
import 'package:kaiteki/ui/shared/text_inherited_icon_theme.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:url_launcher/url_launcher_string.dart';

extension BuildContextExtensions on BuildContext {
  Future<void> showPostDialog({Post? replyTo}) async {
    final key = GlobalKey();
    await showDialog(
      context: this,
      builder: (context) => ComposeScreen(key: key, replyTo: replyTo),
      barrierDismissible: true,
    );
  }

  Future<bool> showWebCompatibilityDialog(ApiType type) async {
    final dialogResult = await showDialog(
      context: this,
      builder: (_) => Center(child: ApiWebCompatibilityDialog(type: type)),
    );
    return dialogResult == true;
  }

  Future<void> showUser(User user, WidgetRef ref) async {
    push("/${ref.getCurrentAccountHandle()}/users/${user.id}", extra: user);
  }

  Future<bool> launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
      return true;
    } else {
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(content: Text(getL10n().failedToLaunchUrl)),
      );
      return false;
    }
  }

  void showErrorSnackbar({
    required Widget text,
    required dynamic error,
    dynamic stackTrace,
  }) {
    final l10n = getL10n();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const TextInheritedIconTheme(
              child: Icon(Icons.error_rounded),
            ),
            const SizedBox(width: 8),
            text,
          ],
        ),
        action: SnackBarAction(
          label: l10n.whyButtonLabel,
          onPressed: () => showExceptionDialog(error, stackTrace),
        ),
      ),
    );
  }

  Future<void> showExceptionDialog(
    dynamic exception,
    StackTrace? stackTrace,
  ) async {
    await showDialog(
      context: this,
      builder: (_) => ExceptionDialog(
        exception: exception,
        stackTrace: stackTrace,
      ),
    );
  }
}
