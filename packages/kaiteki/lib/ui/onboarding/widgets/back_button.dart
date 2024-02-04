import "package:flutter/material.dart";
import "package:kaiteki/di.dart";

class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: const Icon(Icons.chevron_left_rounded),
      label: Text(context.l10n.backButtonLabel),
      onPressed: () => Navigator.of(context).maybePop(),
      style: OutlinedButton.styleFrom(
        visualDensity: VisualDensity.standard,
      ),
    );
  }
}
