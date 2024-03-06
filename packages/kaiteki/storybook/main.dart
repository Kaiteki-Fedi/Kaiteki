import "package:flutter/material.dart";
import "package:kaiteki/theming/fallback.dart";
import "package:kaiteki_l10n/kaiteki_l10n.dart";
import "package:storybook_flutter/storybook_flutter.dart";

import "stories/avatars.dart";
import "stories/count_buttons.dart";
import "stories/dialogs.dart";
import "stories/posts.dart";

void main() => runApp(const KaitekiStorybook());

class KaitekiStorybook extends StatelessWidget {
  const KaitekiStorybook({super.key});

  @override
  Widget build(BuildContext context) {
    return Storybook(
      wrapperBuilder: (context, child) => MaterialApp(
        theme: fallbackTheme,
        darkTheme: fallbackDarkTheme,
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) => Scaffold(
            // backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            body: Center(child: child),
          ),
        ),
        localizationsDelegates: KaitekiLocalizations.localizationsDelegates,
        supportedLocales: KaitekiLocalizations.supportedLocales,
      ),
      stories: [
        discardPost,
        apiWebCompatibility,
        keyboardShortcuts,
        poll,
        avatars,
        countButtons,
      ],
    );
  }
}

final countButtons = Story(
  name: "Count buttons",
  builder: (_) => const CountButtons(),
);
