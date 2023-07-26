import "dart:developer";

import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/l10n/localizations.dart";
import "package:kaiteki/theming/default/themes.dart";
import "package:kaiteki/ui/main/pages/timeline.dart";
import "package:kaiteki/ui/shared/timeline/source.dart";
import "package:kaiteki/ui/shared/timeline/widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/model.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../mocks/timeline_adapter.dart";

void main() {
  late SharedPreferences sharedPreferences;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
  });

  testWidgets("TimelinePage updates Timeline correctly", (tester) async {
    for (final kind in TimelineType.values) {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            adapterProvider.overrideWith(
              (ref) => TimelineAdapter(
                TimelineAdapterCapabilities(
                  TimelineType.values.toSet(),
                ),
              ),
            ),
            sharedPreferencesProvider.overrideWith((_) => sharedPreferences),
          ],
          child: MaterialApp(
            theme: getDefaultTheme(Brightness.light, true),
            localizationsDelegates: KaitekiLocalizations.localizationsDelegates,
            supportedLocales: KaitekiLocalizations.supportedLocales,
            home: const Scaffold(body: TimelinePage()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final tabFinder = find.widgetWithIcon(Tab, kind.getIconData());
      if (tabFinder.evaluate().isEmpty) {
        log("TimelinePage has no tab for $kind");
        continue;
      }

      await tester.tap(tabFinder);

      await tester.pumpAndSettle();

      final timelineFinder = find.byType(Timeline);
      expect(timelineFinder, findsWidgets);

      final timeline = timelineFinder.evaluate().singleOrNull;
      if (timeline == null) {
        log("TimelinePage has more than one Timeline widget");
        continue;
      }

      expect(
        (timeline.widget as Timeline).source,
        predicate((p0) => p0 is StandardTimelineSource && p0.type == kind),
      );
    }
  });
}
