import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/api_type.dart";
import "package:kaiteki/link_constants.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:mdi/mdi.dart";

class MastodonCovenantChip extends StatelessWidget {
  const MastodonCovenantChip({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ActionChip(
      onPressed: () => _onPressed(context),
      backgroundColor: ApiType.mastodon.theme.primaryColor,
      label: Text(
        l10n.usesMastodonCovenant,
        style: const TextStyle(color: Colors.white),
      ),
      avatar: const Icon(
        Mdi.mastodon,
        size: 20,
        color: Colors.white,
      ),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    await context.launchUrl(mastodonCovenantUrl);
  }
}
