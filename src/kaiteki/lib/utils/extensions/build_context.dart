import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/auth/login/dialogs/api_web_compatibility_dialog.dart";
import "package:kaiteki/ui/shared/conversation_screen.dart";
import "package:kaiteki/ui/shared/dialogs/exception_dialog.dart";
import "package:kaiteki/ui/shared/side_sheet_manager.dart";
import "package:kaiteki/ui/window_class.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";
import "package:kaiteki_core/utils.dart";
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

  Future<void> showPost(Post post, WidgetRef ref) async {
    final windowClass = WindowClass.fromContext(this);
    final sideSheetManager = SideSheetManager.of(this);

    if (sideSheetManager != null && windowClass >= WindowClass.medium) {
      sideSheetManager.openSideSheet(
        context: this,
        builder: (_) => ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ConversationScreen(post),
        ),
      );
      return;
    }

    push(
      "/${ref.getCurrentAccountHandle()}/posts/${post.id}",
      extra: post,
    );
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
    required TraceableError error,
  }) {
    final l10n = this.l10n;
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: text,
        action: SnackBarAction(
          label: l10n.whyButtonLabel,
          onPressed: () => showExceptionDialog(error),
        ),
      ),
    );
  }

  Future<void> showExceptionDialog(TraceableError error) async {
    await showDialog(
      context: this,
      builder: (_) => ExceptionDialog(error),
    );
  }
}
