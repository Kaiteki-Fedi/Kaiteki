import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/model/language.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/shared/common.dart";

class ManageLanaguagesScreen extends ConsumerStatefulWidget {
  const ManageLanaguagesScreen({super.key});

  @override
  ConsumerState<ManageLanaguagesScreen> createState() =>
      _ManageLanaguagesScreenState();
}

class _ManageLanaguagesScreenState
    extends ConsumerState<ManageLanaguagesScreen> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final languages = ref.watch(visibleLanguages).value;
    return Scaffold(
      appBar: AppBar(title: const Text("Manage languages")),
      body: ref.watch(languageListProvider).map(
            data: (data) {
              List<Language> list = data.value;

              if (query.isNotEmpty) {
                final q = query.toLowerCase();
                list = list
                    .where(
                      (language) =>
                          language.code.toLowerCase().contains(q) ||
                          language.englishName?.toLowerCase().contains(q) ==
                              true,
                    )
                    .toList();
              }

              return SettingsContainer(
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverToBoxAdapter(
                        child: SearchBar(
                          hintText: "Search languages",
                          leading: const Icon(Icons.search_rounded),
                          elevation: MaterialStateProperty.all(0),
                          onChanged: (value) => setState(() => query = value),
                        ),
                      ),
                    ),
                    SliverList.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final language = list[index];
                        return CheckboxListTile(
                          secondary: DefaultTextStyle.merge(
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            child: Text(
                              language.code.toUpperCase(),
                              style: Theme.of(context)
                                      .ktkTextTheme
                                      ?.monospaceTextStyle ??
                                  DefaultKaitekiTextTheme(context)
                                      .monospaceTextStyle,
                            ),
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
                  ],
                ),
              );
            },
            loading: (_) => centeredCircularProgressIndicator,
            error: (_) => const Center(
              child: Text("There was a problem loading languages"),
            ),
          ),
    );
  }
}
