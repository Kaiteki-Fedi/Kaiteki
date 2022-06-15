import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/interfaces/chat_support.dart';
import 'package:kaiteki/fediverse/interfaces/preview_support.dart';
import 'package:kaiteki/fediverse/interfaces/reaction_support.dart';

class AdapterFeaturesExpansionTile extends StatelessWidget {
  final ApiType type;

  const AdapterFeaturesExpansionTile(this.type, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();
    final name = type.displayName;
    final adapter = type.createAdapter();

    return ExpansionTile(
      title: Text(l10n.aboutBackendTitle(name)),
      children: [
        ListTile(title: Text(l10n.sharedBackendFunctionality(name))),
        _buildFeatureListTile(
          context,
          Icons.forum_rounded,
          l10n.chatSupport,
          adapter is ChatSupport,
        ),
        _buildFeatureListTile(
          context,
          Icons.mood_rounded,
          l10n.reactionSupport,
          adapter is ReactionSupport,
        ),
        _buildFeatureListTile(
          context,
          Icons.rate_review_rounded,
          l10n.previewSupport,
          adapter is PreviewSupport,
        ),
      ],
    );
  }

  Widget _buildFeatureListTile(
    BuildContext context,
    IconData icon,
    String feature,
    bool value,
  ) {
    final l10n = context.getL10n();
    final label = value
        ? l10n.featureSupported(feature)
        : l10n.featureUnsupported(feature);

    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: value
          ? const Icon(Icons.check_rounded)
          : const Icon(Icons.close_rounded),
    );
  }
}
