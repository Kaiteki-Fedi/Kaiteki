import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/ui/settings/customization/theme_selector.dart';

class ThemeSetupPage extends ConsumerWidget {
  const ThemeSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferenceProvider);
    return ThemeSelector(
      theme: prefs.get().theme,
      onSelected: (mode) => prefs.update((p) => p..theme = mode),
    );
  }
}
