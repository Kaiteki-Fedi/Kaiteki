import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/constants.dart' show dialogConstraints;
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/link_constants.dart' show corsHelpArticleUrl;
import 'package:kaiteki/utils/extensions.dart';

class ApiWebCompatibilityDialog extends StatelessWidget {
  final ApiType type;

  const ApiWebCompatibilityDialog({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();
    return AlertDialog(
      icon: const Icon(Icons.error),
      title: Text(l10n.unsupportedInstanceTitle),
      content: SizedBox(
        width: dialogConstraints.minWidth,
        child: Text.rich(
          TextSpan(
            text: l10n.unsupportedInstanceDescriptionCORS(type.displayName),
            children: [
              TextSpan(
                text: corsHelpArticleUrl,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await context.launchUrl(corsHelpArticleUrl);
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
