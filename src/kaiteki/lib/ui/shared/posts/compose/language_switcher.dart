import "package:flutter/material.dart" hide Visibility;
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/model/language.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/ui/adaptive_menu_anchor.dart";

import "language_icon.dart";

class LanguageSwitcher extends ConsumerWidget {
  final String language;
  final Function(String language) onSelected;

  const LanguageSwitcher({
    super.key,
    required this.language,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(languageListProvider.future),
      builder: (context, snapshot) {
        return AdaptiveMenu(
          builder: (context, onTap) {
            return IconButton(
              icon: LanguageIcon(language),
              tooltip: "Language",
              splashRadius: 24,
              onPressed: snapshot.hasData ? onTap : null,
            );
          },
          itemBuilder: (context, onClose) {
            final visible = ref.watch(visibleLanguages).value;
            final languages = snapshot.data;
            var list = languages?.where((e) => visible.contains(e.code));

            if (list?.isEmpty ?? false) {
              list = languages?.where((e) {
                return Localizations.localeOf(context).languageCode == e.code ||
                    e.code == language;
              });
            }

            return [
              for (final tuple in list ?? <Language>[])
                MenuItemButton(
                  leadingIcon: const SizedBox.square(dimension: 24),
                  trailingIcon: language == tuple.code
                      ? const Icon(Icons.check)
                      : const SizedBox.square(dimension: 24),
                  onPressed: () {
                    onSelected.call(tuple.code);
                    onClose?.call();
                  },
                  child: Text(tuple.englishName ?? tuple.code),
                ),
              const Divider(),
              MenuItemButton(
                leadingIcon: const Icon(Icons.add),
                onPressed: () {
                  context.pushNamed("visibleLanguageSettings");
                  onClose?.call();
                },
                trailingIcon: const SizedBox.square(dimension: 24),
                child: const Text("Add a language"),
              ),
            ];
          },
        );
      },
    );
  }
}
