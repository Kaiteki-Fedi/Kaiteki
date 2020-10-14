import 'package:flutter/material.dart';
import 'package:kaiteki/api/model/pleroma/theme.dart';
import 'package:kaiteki/model/fediverse/post.dart';
import 'package:kaiteki/theming/material_app_theme.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:kaiteki/ui/widgets/status_widget.dart';
import 'package:provider/provider.dart';

class ThemePreviewWidget extends StatelessWidget {
  final PleromaTheme pleromaTheme;
  final String defaultName;

  ThemePreviewWidget(this.pleromaTheme, {this.defaultName = "Unnamed"});

  @override
  Widget build(BuildContext context) {
    var fakeContainer = ThemeContainer(MaterialAppTheme(ThemeData.dark()));
    fakeContainer.rawTheme = pleromaTheme;

    return ChangeNotifierProvider.value(
      value: fakeContainer,
      child: AbsorbPointer(
        absorbing: true,
        child: Theme(
          data: fakeContainer.materialTheme,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(pleromaTheme?.name ?? defaultName),
            ),
            body: StatusWidget(Post.example()),
          ),
        ),
      ),
    );
  }
}
