import "package:flutter/material.dart";
import "package:kaiteki/constants.dart" show dialogConstraints;
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/api_type.dart";
import "package:kaiteki/fediverse/interfaces/bookmark_support.dart";
import "package:kaiteki/fediverse/interfaces/chat_support.dart";
import "package:kaiteki/fediverse/interfaces/preview_support.dart";
import "package:kaiteki/fediverse/interfaces/reaction_support.dart";

class CapabilitiesDialog extends StatelessWidget {
  final ApiType type;

  const CapabilitiesDialog({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final adapter = type.createAdapter("");
    final l10n = context.l10n;
    final otherCapabilities = _buildOtherCapabilities(context);
    return ConstrainedBox(
      constraints: dialogConstraints,
      child: AlertDialog(
        icon: const Icon(Icons.check_circle_rounded),
        title: const Text("Supported features"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.sharedBackendFunctionality(type.displayName)),
              if (adapter is ChatSupport)
                _buildFeatureListTile(
                  context,
                  const Icon(Icons.forum_rounded),
                  l10n.chatSupport,
                  l10n.chatSupportDescription,
                ),
              if (adapter is ReactionSupport)
                _buildFeatureListTile(
                  context,
                  const Icon(Icons.mood_rounded),
                  l10n.reactionSupport,
                  l10n.reactionSupportDescription,
                ),
              if (adapter is PreviewSupport)
                _buildFeatureListTile(
                  context,
                  const Icon(Icons.rate_review_rounded),
                  l10n.previewSupport,
                  l10n.previewSupportDescription,
                ),
              if (adapter is BookmarkSupport)
                _buildFeatureListTile(
                  context,
                  const Icon(Icons.bookmark_rounded),
                  l10n.bookmarkSupport,
                  l10n.bookmarkSupportDescription,
                ),
              if (otherCapabilities.isNotEmpty)
                ExpansionTile(
                  title: const Text("Other features"),
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  children: otherCapabilities,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.closeButtonLabel),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOtherCapabilities(BuildContext context) {
    return [
      //if (adapter is ReportSupport)
      //  _buildFeatureListTile(
      //    context,
      //    const Icon(Icons.flag_rounded),
      //    l10n.reportSupport,
      //    l10n.reportSupportDescription,
      //  ),
    ];
  }

  Widget _buildFeatureListTile(
    BuildContext context,
    Icon icon,
    String feature,
    String description,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: icon,
      title: Text(feature),
      subtitle: Text(description),
    );
  }
}
