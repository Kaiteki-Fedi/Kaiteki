import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/theming/default_app_themes.dart';
import 'package:widgetbook/widgetbook.dart';

import 'categories/dialogs.dart';
import 'categories/posts.dart';
import 'categories/user.dart';

class HotReload extends StatelessWidget {
  const HotReload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      categories: [
        WidgetbookCategory(
          name: "Posts",
          widgets: buildPostComponents(),
        ),
        WidgetbookCategory(
          name: "Dialogs",
          widgets: buildDialogComponents(),
        ),
        WidgetbookCategory(
          name: "Users",
          widgets: buildUserComponents(),
        ),
      ],
      themes: [
        WidgetbookTheme(name: "Light", data: lightThemeData),
        WidgetbookTheme(name: "Dark", data: darkThemeData),
      ],
      devices: getDevices(),
      appInfo: AppInfo(name: consts.appName),
    );
  }

  List<Device> getDevices() {
    return [
      Device(
        name: 'Monitor',
        resolution: Resolution.dimensions(
          nativeWidth: 1920,
          nativeHeight: 1080,
          scaleFactor: 1,
        ),
        type: DeviceType.desktop,
      ),
      Device(
        name: 'Laptop',
        resolution: Resolution.dimensions(
          nativeWidth: 1366,
          nativeHeight: 768,
          scaleFactor: 1,
        ),
        type: DeviceType.desktop,
      ),
      Device(
        name: 'Samsung Galaxy Star 2 Plus',
        resolution: Resolution.dimensions(
          nativeWidth: 480,
          nativeHeight: 800,
          scaleFactor: 1,
        ),
        type: DeviceType.mobile,
      ),
    ];
  }
}
