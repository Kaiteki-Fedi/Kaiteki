import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/ui/settings/customization/theme_selector.dart';
import 'package:kaiteki/ui/shared/text_inherited_icon_theme.dart';

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
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: _SystemSettingsDisclaimer(),
          ),
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

class _SystemSettingsDisclaimer extends StatelessWidget {
  const _SystemSettingsDisclaimer();

  @override
  Widget build(BuildContext context) {
    final color = Colors.lightBlueAccent.harmonizeWith(
      Theme.of(context).colorScheme.primary,
    );
    final localFontSize = DefaultTextStyle.of(context).style.fontSize;

    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withOpacity(.25),
          border: BorderDirectional(
            start: BorderSide(color: color, width: 4.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_rounded, color: color),
              const SizedBox(width: 8.0),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: localFontSize! * 0.125),
                  child: const Text.rich(
                    TextSpan(
                      text:
                          "Some settings are automatically provided by your system and marked as indeterminate (",
                      children: [
                        WidgetSpan(
                          child: TextInheritedIconTheme(
                            child: Icon(Icons.indeterminate_check_box_rounded),
                          ),
                          alignment: PlaceholderAlignment.middle,
                          baseline: TextBaseline.alphabetic,
                        ),
                        TextSpan(text: ") by default."),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ColorCircle extends StatelessWidget {
  const ColorCircle({
    super.key,
    required this.color,
  });

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
