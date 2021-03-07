import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/theming/app_theme_source.dart';
import 'package:kaiteki/theming/material_app_theme.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:kaiteki/ui/widgets/status_widget.dart';
import 'package:provider/provider.dart';

class ThemePreviewWidget extends StatelessWidget {
  final AppThemeSource theme;
  final String defaultName;

  ThemePreviewWidget(this.theme, {this.defaultName = "Unnamed"});

  @override
  Widget build(BuildContext context) {
    var fakeContainer = ThemeContainer(MaterialAppTheme(ThemeData.dark()));
    fakeContainer.source = theme;

    return ChangeNotifierProvider.value(
      value: fakeContainer,
      child: AbsorbPointer(
        absorbing: true,
        child: Theme(
          data: fakeContainer.getMaterialTheme(),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text("Preview"),
            ),
            body: StatusWidget(Post.example()),
          ),
        ),
      ),
    );
  }
}
