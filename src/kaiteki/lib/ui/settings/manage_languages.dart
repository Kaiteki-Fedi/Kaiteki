import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/utils/extensions.dart";

class ManageLanaguagesScreen extends ConsumerWidget {
  const ManageLanaguagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languages = ref.watch(visibleLanguages).value;
    return Scaffold(
      appBar: AppBar(title: const Text("Manage languages")),
      body: ref.watch(languageListProvider).map(
            data: (data) => SettingsContainer(
              child: ListView.builder(
                itemCount: data.value.length,
                itemBuilder: (context, index) {
                  final language = data.value[index];
                  return CheckboxListTile(
                    secondary: Text(
                      language.code.toUpperCase(),
                      style: Theme.of(context)
                          .ktkTextTheme
                          ?.monospaceTextStyle
                          .fallback
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    value: languages.contains(language.code),
                    title: Text(language.englishName ?? language.code),
                    onChanged: (value) {
                      ref.read(visibleLanguages).value = value == true
                          ? languages.add(language.code)
                          : languages.remove(language.code);
                    },
                  );
                },
              ),
            ),
            loading: (_) => const Center(child: CircularProgressIndicator()),
            error: (_) => const Center(
              child: Text("There was a problem loading languages"),
            ),
          ),
    );
  }
}
