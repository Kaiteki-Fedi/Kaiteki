import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/model/emoji.dart';
import 'package:kaiteki/model/account_key.dart';
import 'package:kaiteki/model/auth/account_compound.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/theming/default/themes.dart';
import 'package:kaiteki/ui/main/main_screen.dart';
import 'package:kaiteki/ui/user/user_screen.dart';

import 'dummy_adapter.dart';
import 'dummy_repository.dart';
import 'example_data.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Main screen',
    (tester) async {
      await tester.setScreenSize(1280, 720);
      final bootstrapper = await Bootstrapper.getInstance();
      runApp(bootstrapper.wrap(const MainScreen()));
      await tester.pumpAndSettle();
      await precacheImages(tester.allStates.first.context);
      await takeScreenshot<MainScreen>("main-screen.png");
    },
  );

  testWidgets(
    'User screen',
    (tester) async {
      await tester.setScreenSize(1280, 720);
      final bootstrapper = await Bootstrapper.getInstance();
      runApp(bootstrapper.wrap(UserScreen.fromUser(alice)));
      await tester.pumpAndSettle();
      await precacheImages(tester.allStates.first.context);
      await takeScreenshot<UserScreen>("user-screen.png");
    },
  );
}

Future<void> precacheImages(BuildContext context) async {
  final urls = [
    ...users.map((u) => u.bannerUrl),
    ...users.map((u) => u.avatarUrl),
    ...posts.expand<String?>(
      (p) => p.emojis?.whereType<CustomEmoji>().map((e) => e.url) ?? [],
    ),
  ];

  for (final url in urls) {
    if (url != null) {
      log("Precaching $url...");
      await precacheImage(
        NetworkImage(url),
        context,
      );
    }
  }
}

Future<void> takeScreenshot<T extends Widget>(String path) async {
  final element = find.byType(T, skipOffstage: false).evaluate().first;
  final image = await captureImage(element);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  await File(path).writeAsBytes(
    data!.buffer.asUint8List(),
    flush: true,
  );
}

class Bootstrapper {
  final FediverseAdapter adapter;
  final AccountManager accountManager;

  const Bootstrapper._(this.adapter, this.accountManager);

  static Future<Bootstrapper> getInstance() async {
    final accountRepo = DummyRepository<AccountSecret, AccountKey>();
    final clientRepo = DummyRepository<ClientSecret, AccountKey>();
    final accountManager = AccountManager(accountRepo, clientRepo);
    final adapter = DummyAdapter(
      DummyClient("instance"),
      posts: posts,
      users: [alice],
    );
    final account = Account(
      accountSecret: const AccountSecret(""),
      clientSecret: const ClientSecret("", ""),
      adapter: adapter,
      key: AccountKey(ApiType.mastodon, alice.host, alice.username),
      user: alice,
    );
    await accountManager.add(account);
    return Bootstrapper._(adapter, accountManager);
  }

  Widget wrap(Widget child) {
    return ProviderScope(
      overrides: [
        accountProvider.overrideWithProvider(
          ChangeNotifierProvider((_) => accountManager),
        ),
        adapterProvider.overrideWithProvider(
          Provider((_) => adapter),
        ),
      ],
      child: MaterialApp(
        home: child,
        useInheritedMediaQuery: true,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale("en"),
        theme: getTheme(Brightness.light, true),
      ),
    );
  }
}

Future<ui.Image> captureImage(Element element) {
  assert(element.renderObject != null);
  var renderObject = element.renderObject!;
  while (!renderObject.isRepaintBoundary) {
    renderObject = renderObject.parent! as RenderObject;
  }
  assert(!renderObject.debugNeedsPaint);
  final layer = renderObject.debugLayer! as OffsetLayer;
  return layer.toImage(renderObject.paintBounds);
}

extension SetScreenSize on WidgetTester {
  Future<void> setScreenSize(
    double width,
    double height, {
    double pixelDensity = 1,
  }) async {
    final size = Size(width, height);
    await binding.setSurfaceSize(size);
    binding.window.physicalSizeTestValue = size;
    binding.window.devicePixelRatioTestValue = pixelDensity;
  }
}
