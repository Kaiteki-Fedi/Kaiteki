import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/timeline_kind.dart';
import 'package:kaiteki/theming/default/themes.dart';
import 'package:kaiteki/ui/main/pages/timeline.dart';
import 'package:kaiteki/ui/shared/timeline.dart';
import 'package:kaiteki/utils/extensions.dart';

import '../mocks/timeline_adapter.dart';

void main() {
  testWidgets('TimelinePage updates Timeline correctly', (tester) async {
    for (final kind in TimelineKind.values) {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            adapterProvider.overrideWith(
              (ref) => TimelineAdapter(
                TimelineAdapterCapabilities(
                  TimelineKind.values.toSet(),
                ),
              ),
            )
          ],
          child: MaterialApp(
            theme: getDefaultTheme(Brightness.light, true),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
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

      expect((timeline.widget as Timeline).kind, equals(kind));
    }
  });
}
