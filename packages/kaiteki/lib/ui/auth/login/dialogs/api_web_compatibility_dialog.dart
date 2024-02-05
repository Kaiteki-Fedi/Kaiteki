import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:kaiteki/constants.dart" show kDialogConstraints;
import "package:kaiteki/di.dart";
import "package:kaiteki/link_constants.dart" show corsHelpArticleUrl;
import "package:kaiteki_core_backends/kaiteki_core_backends.dart";
import "package:url_launcher/url_launcher_string.dart";

class ApiWebCompatibilityDialog extends StatelessWidget {
  final BackendType type;

  const ApiWebCompatibilityDialog({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      icon: const Icon(Icons.error),
      title: Text(l10n.unsupportedInstanceTitle),
      content: SizedBox(
        width: kDialogConstraints.minWidth,
        child: Text.rich(
          TextSpan(
            text: l10n.unsupportedInstanceDescriptionCORS(type.name),
            children: [
              TextSpan(
                text: corsHelpArticleUrl,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await launchUrlString(corsHelpArticleUrl);
                  },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text(l10n.continueAnywayButtonLabel),
          onPressed: () => Navigator.pop(context, true),
        ),
        TextButton(
          child: Text(l10n.abortButtonLabel),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
