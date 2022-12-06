import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kaiteki/theming/default/themes.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

import 'stories/dialogs.dart';

void main() => runApp(const KaitekiStorybook());

class KaitekiStorybook extends StatelessWidget {
  const KaitekiStorybook({super.key});

  @override
  Widget build(BuildContext context) {
    return Storybook(
      wrapperBuilder: (context, child) => MaterialApp(
        theme: getTheme(Brightness.light, true),
        darkTheme: getTheme(Brightness.dark, true),
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        home: Builder(
          builder: (context) => Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            body: Center(child: child),
          ),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
      stories: [
        discardPost,
        apiWebCompatibility,
        keyboardShortcuts,
      ],
    );
  }
}
