import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/theme_preferences.dart";

import "density_dialog.dart";

class DensityListTile extends ConsumerWidget {
  const DensityListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> onTap() async {
      final result = await showDialog(
        context: context,
        builder: (_) => DensityDialog(
          visualDensity: ref.read(visualDensity).value,
        ),
      );

      if (result == null) return;

      ref.read(visualDensity).value =
          result is CustomDensityDialogResult ? result.visualDensity : null;
    }

    final currentVisualDensity = ref.watch(visualDensity).value;
    return ListTile(
      title: const Text("Density"),
      subtitle: Text(
        currentVisualDensity == null
            ? "System"
            : getNameForDensity(currentVisualDensity) ??
                currentVisualDensity.toString(),
      ),
      onTap: onTap,
    );
  }
}

String? getNameForDensity(VisualDensity density) {
  return switch (density) {
    VisualDensity.standard => "Standard",
    VisualDensity.comfortable => "Comfortable",
    VisualDensity.compact => "Compact",
    _ => null
  };
}
