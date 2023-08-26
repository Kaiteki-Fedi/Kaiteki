import "dart:developer";
import "dart:io";
import "dart:typed_data";
import "dart:ui" as ui;

import "package:flutter/material.dart" hide Visibility;
import "package:flutter/rendering.dart" show NetworkImage, OffsetLayer, Size;
import "package:flutter_test/flutter_test.dart";
import "package:integration_test/integration_test.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/main/main_screen.dart";
import "package:kaiteki/ui/shared/posts/compose/compose_screen.dart";
import "package:kaiteki/ui/user/user_screen.dart";
import "package:kaiteki_core/model.dart";
import "package:path/path.dart" as path;

import "bootstrapper.dart";
import "example_data.dart";

class ScreenConfig {
  final Size size;
  final double density;

  ScreenConfig(int width, int height, this.density)
      : size = Size(width.toDouble(), height.toDouble());
}

List<String> get locales => [
      "en_US",
      "de_DE",
      "ja_JP",
      "fr_FR",
    ];

const duration = Duration(milliseconds: 100);
const timeout = Duration(seconds: 10);

// https://stackoverflow.com/a/25054998/7972419
final deviceTypes = {
  "phoneScreenshots": ScreenConfig(360, 640, 1),
  "sevenInchScreenshots": ScreenConfig(1024, 600, 1), // Kindle Fire
  "tenInchScreenshots":
      ScreenConfig(1280, 800, 1), // Galaxy Tab (div'd by density)
};

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  for (final deviceType in deviceTypes.entries) {
    for (final locale in locales) {
      final directoryPath = path.joinAll([
        "fastlane",
        "metadata",
        "android",
        locale.replaceAll("_", "-"),
        "images",
        deviceType.key,
      ]);

      final directory = Directory(directoryPath);
      if (!directory.existsSync()) directory.createSync(recursive: true);

      final screenshots = <String, Uint8List>{};

      takeScreenshots(
        screenshots,
        screenSize: deviceType.value.size,
        screenDensity: deviceType.value.density,
        locale: locale.split("_").first,
      );

      tearDownAll(() async {
        for (var i = 0; i < screenshots.length; i++) {
          final filePath = path.join(directoryPath, "$i.png");
          final bytes = screenshots.values.elementAt(i);
          await File(filePath).writeAsBytes(bytes, flush: true);
        }
      });
    }
  }
}

void takeScreenshots(
  Map<String, Uint8List> map, {
  required Size screenSize,
  double screenDensity = 1,
  String? locale,
}) {
  testWidgets(
    "Main screen",
    (tester) async {
      await tester.setScreenSize(screenSize, screenDensity);
      final bootstrapper = await Bootstrapper.getInstance(locale);
      runApp(
        bootstrapper.wrap(
          const MainScreen(initialTimeline: TimelineType.federated),
          screenSize,
        ),
      );
      await tester.pumpAndSettle(
        duration,
        EnginePhase.sendSemanticsUpdate,
        timeout,
      );
      await precacheImages(tester.allStates.first.context);
      map["main-screen"] = await takeScreenshot<MainScreen>();
    },
  );

  testWidgets(
    "Compose screen",
    (tester) async {
      await tester.setScreenSize(screenSize, screenDensity);
      final bootstrapper = await Bootstrapper.getInstance(locale);
      runApp(
        bootstrapper.wrap(
          const ComposeScreen(),
          screenSize,
        ),
      );
      await tester.pumpAndSettle(
        duration,
        EnginePhase.sendSemanticsUpdate,
        timeout,
      );
      await precacheImages(tester.allStates.first.context);
      map["compose-screen"] = await takeScreenshot<ComposeScreen>();
    },
  );

  testWidgets(
    "User screen",
    (tester) async {
      await tester.setScreenSize(screenSize, screenDensity);
      final bootstrapper = await Bootstrapper.getInstance(locale);

      final adapter = bootstrapper.container.read(adapterProvider);
      final user = await adapter.getUserById("109349633552584749");

      runApp(
        bootstrapper.wrap(
          UserScreen.fromUser(user: user!),
          screenSize,
        ),
      );
      await tester.pumpAndSettle(
        duration,
        EnginePhase.sendSemanticsUpdate,
        timeout,
      );

      await Future.delayed(const Duration(seconds: 1));

      await precacheImages(tester.allStates.first.context);
      map["user-screen"] = await takeScreenshot<UserScreen>();
    },
  );
}

Future<void> precacheImages(BuildContext context) async {
  final urls = [
    ...users.map((u) => u.bannerUrl),
    ...users.map((u) => u.avatarUrl),
    ...posts.expand<String?>(
      (p) {
        return p.emojis
                ?.whereType<CustomEmoji>()
                .map((e) => e.url.toString()) ??
            [];
      },
    ),
  ];

  for (final url in urls) {
    if (url == null) continue;
    log("Precaching $url...");
    await precacheImage(NetworkImage(url.toString()), context);
    log("Cached $url...");
  }
}

Future<Uint8List> takeScreenshot<T extends Widget>() async {
  final element = find.byType(T, skipOffstage: false).evaluate().first;
  final image = await captureImage(element);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}

Future<ui.Image> captureImage(Element element) {
  assert(element.renderObject != null);
  var renderObject = element.renderObject!;
  while (!renderObject.isRepaintBoundary) {
    renderObject = renderObject.parent!;
  }
  assert(!renderObject.debugNeedsPaint);
  final layer = renderObject.debugLayer! as OffsetLayer;
  return layer.toImage(renderObject.paintBounds);
}

extension SetScreenSize on WidgetTester {
  Future<void> setScreenSize(Size size, [double pixelDensity = 1]) async {
    await binding.setSurfaceSize(size);
    view
      ..physicalSize = size
      ..devicePixelRatio = pixelDensity;
  }
}
