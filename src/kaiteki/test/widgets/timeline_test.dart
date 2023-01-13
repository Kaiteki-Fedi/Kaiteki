import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/model/timeline_kind.dart";
import "package:kaiteki/theming/default/themes.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";
import "package:kaiteki/ui/shared/timeline.dart";

import "../mocks/timeline_adapter.dart";

void main() {
  testWidgets("Timeline changed after kind switch", (tester) async {
    Widget wrapper(Widget widget) {
      return ProviderScope(
        overrides: [
          adapterProvider.overrideWith(
            (ref) => TimelineAdapter(TimelineAdapterCapabilities()),
          ),
        ],
        child: MaterialApp(
          theme: getDefaultTheme(Brightness.light, true),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: widget),
        ),
      );
    }

    // Switch to home timeline
    await tester.pumpWidget(
      wrapper(const Timeline.kind()),
    );

    await tester.pumpAndSettle();
    expect(find.text(TimelineKind.home.toString()), findsOneWidget);

    // Switch to federated timeline
    await tester.pumpWidget(
      wrapper(const Timeline.kind(kind: TimelineKind.federated)),
    );

    await tester.pumpAndSettle();
    expect(find.text(TimelineKind.federated.toString()), findsOneWidget);
  });

  testWidgets("Timeline shows failures properly", (tester) async {
    Widget wrapper(Widget widget) {
      return ProviderScope(
        overrides: [
          adapterProvider.overrideWith((ref) {
            return TimelineAdapter(
              TimelineAdapterCapabilities(),
              {TimelineKind.federated, TimelineKind.hybrid},
            );
          }),
        ],
        child: MaterialApp(
          theme: getDefaultTheme(Brightness.light, true),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: widget),
        ),
      );
    }

    // Switch to home timeline
    await tester.pumpWidget(
      wrapper(const Timeline.kind()),
    );

    await tester.pumpAndSettle();
    expect(find.text(TimelineKind.home.toString()), findsOneWidget);

    // Switch to federated timeline
    await tester.pumpWidget(
      wrapper(const Timeline.kind(kind: TimelineKind.federated)),
    );

    await tester.pumpAndSettle();
    expect(find.byType(IconLandingWidget), findsOneWidget);

    // Switch to hybrid timeline
    await tester.pumpWidget(
      wrapper(const Timeline.kind(kind: TimelineKind.hybrid)),
    );

    await tester.pumpAndSettle();
    expect(find.byType(IconLandingWidget), findsOneWidget);
  });
}
