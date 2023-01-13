import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";

class OAuthPage extends StatelessWidget {
  final VoidCallback? onCancel;

  const OAuthPage({this.onCancel, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconLandingWidget(
            icon: const Icon(Icons.key_rounded),
            text: Text(l10n.authOAuthPending),
          ),
          if (onCancel != null) ...[
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onCancel,
              child: Text(l10n.cancelButtonLabel),
            ),
          ],
        ],
      ),
    );
  }
}
