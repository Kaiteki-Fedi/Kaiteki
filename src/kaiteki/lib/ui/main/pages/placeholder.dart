import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: IconLandingWidget(
        icon: const Icon(Icons.more_horiz_rounded),
        text: Text(l10n.niy),
      ),
    );
  }
}
