import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/link_constants.dart' show federationCovenantUrl;
import 'package:kaiteki/utils/extensions.dart';

class FediverseCovenantChip extends StatelessWidget {
  const FediverseCovenantChip({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return ActionChip(
      onPressed: () => _onPressed(context),
      backgroundColor: colorScheme.secondary,
      label: Text(
        l10n.usesFediverseCovenant,
        style: TextStyle(color: colorScheme.onSecondary),
      ),
      avatar: Icon(
        Icons.star_rounded,
        size: 20,
        color: colorScheme.onSecondary,
      ),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    await context.launchUrl(federationCovenantUrl);
  }
}
