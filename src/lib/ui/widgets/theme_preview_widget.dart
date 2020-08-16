import 'package:flutter/material.dart';
import 'package:kaiteki/api/model/mastodon/status.dart';
import 'package:kaiteki/theming/pleroma_theme.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:kaiteki/ui/widgets/status_widget.dart';
import 'package:provider/provider.dart';

class ThemePreviewWidget extends StatelessWidget {
  final PleromaTheme pleromaTheme;
  final String defaultName;

  ThemePreviewWidget(this.pleromaTheme, {this.defaultName = "Unnamed"});

  @override
  Widget build(BuildContext context) {
    var fakeContainer = ThemeContainer(ThemeData.dark());
    fakeContainer.changePleromaTheme(pleromaTheme);

    return ChangeNotifierProvider.value(
      value: fakeContainer,
      child: AbsorbPointer(
        absorbing: true,
        child: Theme(
          data: fakeContainer.getCurrentTheme(),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(pleromaTheme?.name ?? defaultName),
            ),
            body: StatusWidget(Status.example()),
          ),
        ),
      ),
    );
  }
}
