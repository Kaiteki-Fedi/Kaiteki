import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

class AlphaDisclaimer extends StatelessWidget {
  const AlphaDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cautionColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.yellowAccent,
      brightness: theme.brightness,
    );
    final cautionColor = cautionColorScheme.onPrimaryContainer
        .harmonizeWith(theme.colorScheme.onPrimaryContainer);
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
        color: cautionColorScheme.primaryContainer
            .harmonizeWith(theme.colorScheme.primaryContainer),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_rounded, color: cautionColor, size: 18),
            const SizedBox(width: 8.0),
            Flexible(
              child: Text.rich(
                style: TextStyle(color: cautionColor, height: 1.35),
                TextSpan(
                  children: [
                    const TextSpan(text: "Kaiteki is "),
                    const TextSpan(
                      text: "alpha",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: " software. "),
                    TextSpan(
                      text: "What does this mean?",
                      style:
                          const TextStyle(decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final url = Uri.parse("");
                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
