import "package:flutter/material.dart" hide BackButton;
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/ui/onboarding/widgets/back_button.dart";

class ThemePage extends ConsumerWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Select a theme",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(
            "Choose a theme that suits you.",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card.outlined(
                    clipBehavior: Clip.antiAlias,
                    child: RadioListTile(
                      title: Text(context.l10n.themeSystem),
                      value: ThemeMode.system,
                      groupValue: ref.watch(themeMode).value,
                      onChanged: (value) => ref.read(themeMode).value = value!,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card.outlined(
                    clipBehavior: Clip.antiAlias,
                    child: RadioListTile(
                      title: Text(context.l10n.themeLight),
                      value: ThemeMode.light,
                      groupValue: ref.watch(themeMode).value,
                      onChanged: (value) => ref.read(themeMode).value = value!,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card.outlined(
                    clipBehavior: Clip.antiAlias,
                    child: RadioListTile(
                      title: Text(context.l10n.themeDark),
                      value: ThemeMode.dark,
                      groupValue: ref.watch(themeMode).value,
                      onChanged: (value) => ref.read(themeMode).value = value!,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackButton(),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  ref.read(hasFinishedOnboarding).value = true;
                  context.go("/");
                },
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.standard,
                ),
                child: Text(context.l10n.finishButtonLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
