import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/ui/settings/customization/theme_selector.dart';

class CustomizationBasicPage extends ConsumerStatefulWidget {
  const CustomizationBasicPage({Key? key}) : super(key: key);

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
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: Text(
              l10n.theme,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ThemeSelector(
              theme: prefs.mode,
              onSelected: (mode) => prefs.mode = mode,
            ),
          ),
          CheckboxListTile(
            value: prefs.useMaterial3,
            title: const Text("Use Material You"),
            controlAffinity: ListTileControlAffinity.leading,
            tristate: true,
            onChanged: (value) => setState(() => prefs.useMaterial3 = value),
          ),
        ],
      ),
    );
  }
}

class ColorCircle extends StatelessWidget {
  const ColorCircle({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}
