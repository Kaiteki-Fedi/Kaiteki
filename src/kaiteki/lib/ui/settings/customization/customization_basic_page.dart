import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/ui/settings/customization/theme_selector.dart';

class CustomizationBasicPage extends ConsumerStatefulWidget {
  const CustomizationBasicPage({super.key});

  @override
  ConsumerState<CustomizationBasicPage> createState() =>
      _CustomizationBasicPageState();
}

class _CustomizationBasicPageState
    extends ConsumerState<CustomizationBasicPage> {
  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(themeProvider);
    final l10n = context.getL10n();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(l10n.theme),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ThemeSelector(
              theme: prefs.mode,
              onSelected: (mode) => prefs.mode = mode,
            ),
          ),
          SwitchListTile(
            value: prefs.useMaterial3,
            title: Text(l10n.useMaterialYou),
            onChanged: (value) => setState(() => prefs.useMaterial3 = value),
          ),
          SwitchListTile(
            value: prefs.useSystemColorScheme,
            title: Text(l10n.useSystemColorScheme),
            onChanged: (value) =>
                setState(() => prefs.useSystemColorScheme = value),
          ),
        ],
      ),
    );
  }
}
