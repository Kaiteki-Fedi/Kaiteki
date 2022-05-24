import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/theming/app_theme_source.dart';
import 'package:kaiteki/theming/app_themes/material_app_theme.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:kaiteki/ui/widgets/post_widget.dart';
import 'package:provider/provider.dart';

class ThemePreviewWidget extends StatelessWidget {
  final AppThemeSource theme;
  final String defaultName;

  const ThemePreviewWidget(
    this.theme, {
    this.defaultName = "Unnamed",
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fakeContainer = ThemeContainer(
      MaterialAppTheme(ThemeData.dark()),
    )..source = theme;

    return ChangeNotifierProvider.value(
      value: fakeContainer,
      child: AbsorbPointer(
        child: Theme(
          data: fakeContainer.getMaterialTheme(),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text("Preview"),
            ),
            body: PostWidget(Post.example()),
          ),
        ),
      ),
    );
  }
}
