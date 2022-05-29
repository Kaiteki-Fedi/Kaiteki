import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/fediverse/model/visibility.dart';
import 'package:kaiteki/theming/app_themes/default_app_themes.dart';
import 'package:kaiteki/ui/dialogs/api_type_dialog.dart';
import 'package:kaiteki/ui/dialogs/api_web_compatibility_dialog.dart';
import 'package:kaiteki/ui/widgets/post_widget.dart';
import 'package:widgetbook/widgetbook.dart';

import 'widgetboot_extensions.dart';

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
          widgets: [
            WidgetbookComponent(
              name: "PostWidget",
              useCases: [
                WidgetbookUseCase(
                  name: "Example post",
                  builder: (context) {
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: PostWidget(
                          Post.example(),
                        ),
                      ),
                    );
                  },
                ),
                WidgetbookUseCase(
                  name: "Customizable post",
                  builder: (context) {
                    final user = User(
                      displayName: context.knobs.text(
                        label: "Display name",
                        initialValue: "User",
                      ),
                      host: context.knobs.text(
                        label: "Instance",
                        initialValue: "instance.social",
                      ),
                      id: '',
                      avatarUrl: context.knobs.nullableText(
                        label: "Avatar URL",
                      ),
                      source: null,
                      username: context.knobs.text(
                        label: "Username",
                        initialValue: "User",
                      ),
                    );
                    final post = Post(
                      author: user,
                      id: '',
                      postedAt: DateTime.now().subtract(
                        const Duration(minutes: 1),
                      ),
                      source: null,
                      visibility: context.knobs.enumOptions(
                        values: Visibility.values,
                        label: "Visibility",
                      ),
                      content: context.knobs.nullableText(label: "Content"),
                    );
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: PostWidget(post),
                      ),
                    );
                  },
                )
              ],
            )
          ],
        ),
        WidgetbookCategory(
          name: "Dialogs",
          widgets: [
            WidgetbookComponent(
              name: "ApiWebCompatibilityDialog",
              useCases: [
                WidgetbookUseCase(
                  name: "Default",
                  builder: (context) {
                    return ColoredBox(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: Center(
                        child: ApiWebCompatibilityDialog(
                          type: context.knobs.enumOptions(
                            label: "API type",
                            values: ApiType.values,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(
              name: "ApiTypeDialog",
              useCases: [
                WidgetbookUseCase(
                  name: "Default",
                  builder: (context) {
                    return ColoredBox(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: const Center(child: ApiTypeDialog()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
      themes: [
        WidgetbookTheme(name: "Light", data: lightThemeData),
        WidgetbookTheme(name: "Dark", data: darkThemeData),
      ],
      devices: [
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
      ],
      appInfo: AppInfo(name: consts.appName),
    );
  }
}
