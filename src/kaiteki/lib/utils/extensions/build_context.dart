import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/api_type.dart";
import "package:kaiteki/fediverse/model/user/user.dart";
import "package:kaiteki/ui/auth/login/dialogs/api_web_compatibility_dialog.dart";
import "package:kaiteki/ui/shared/dialogs/exception_dialog.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:url_launcher/url_launcher.dart" as url_launcher;

extension BuildContextExtensions on BuildContext {
  Future<bool> showWebCompatibilityDialog(ApiType type) async {
    final dialogResult = await showDialog(
      context: this,
      builder: (_) => Center(child: ApiWebCompatibilityDialog(type: type)),
    );
    return dialogResult == true;
  }

  Future<void> showUser(User user, WidgetRef ref) async {
    // FIXME(Craftplacer): We aren't able to pass an user object as parameter, https://github.com/Kaiteki-Fedi/Kaiteki/issues/195
    push("/${ref.getCurrentAccountHandle()}/users/${user.id}");
  }

  Future<void> launchUrl(String url) async {
    final uri = Uri.parse(url);
    await url_launcher.launchUrl(
      uri,
      mode: url_launcher.LaunchMode.externalApplication,
    );
  }

  void showErrorSnackbar({
    required Widget text,
    required Object error,
    StackTrace? stackTrace,
  }) {
    final l10n = this.l10n;
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: text,
        action: SnackBarAction(
          label: l10n.whyButtonLabel,
          onPressed: () => showExceptionDialog(error, stackTrace),
        ),
      ),
    );
  }

  Future<void> showExceptionDialog(
    Object exception,
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
