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
    final prefs = ref.watch(preferenceProvider);
    final l10n = context.getL10n();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Text(
              l10n.theme,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ThemeSelector(
              theme: prefs.get().theme,
              onSelected: (mode) => prefs.update((p) => p..theme = mode),
            ),
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
