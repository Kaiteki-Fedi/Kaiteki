import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/ui/settings/customization/theme_selector.dart';

class ThemeSetupPage extends ConsumerWidget {
  const ThemeSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(themeProvider);
    return ThemeSelector(
      theme: prefs.mode,
      onSelected: (mode) => prefs.mode = mode,
    );
  }
}
