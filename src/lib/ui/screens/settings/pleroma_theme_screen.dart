import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:kaiteki/theming/pleroma_theme.dart';
import 'package:kaiteki/ui/pages/theme/common_page.dart';
import 'package:kaiteki/ui/pages/theme/fonts_page.dart';
import 'package:kaiteki/ui/pages/theme/preview_page.dart';
import 'package:kaiteki/ui/pages/theme/roundness_page.dart';
import 'package:kaiteki/ui/widgets/icon_landing_widget.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class PleromaThemeScreen extends StatefulWidget {
  PleromaThemeScreen({Key key}) : super(key: key);

  @override
  _PleromaThemeScreenState createState() =>
      _PleromaThemeScreenState();
}

class _PleromaThemeScreenState extends State<PleromaThemeScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;

  var _tabs = <Widget>[
    Tooltip(
      message: "Preview",
      child: Tab(
        icon: Icon(Mdi.eye),
      ),
    ),
    Tooltip(
      message: "Common",
      child: Tab(
        icon: Icon(Mdi.palette),
      ),
    ),
    Tooltip(
      message: "Advanced",
      child: Tab(
        icon: Icon(Mdi.more),
      ),
    ),
    Tooltip(
      message: "Roundness",
      child: Tab(
        icon: Icon(Mdi.roundedCorner),
      ),
    ),
    Tooltip(
      message: "Shadow and lighting",
      child: Tab(
        icon: Icon(Mdi.boxShadow),
      ),
    ),
    Tooltip(
      message: "Fonts",
      child: Tab(
        icon: Icon(Mdi.formatFont),
      ),
    )
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }



  void resetTheme() {
    var container = Provider.of<ThemeContainer>(context, listen: false);
    container.changePleromaTheme(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Pleroma Theme"),
        actions: [
          IconButton(
            icon: Icon(Mdi.undo),
            tooltip: "Reset to default",
            onPressed: resetTheme,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PreviewPage(),
          CommonPage(),
          IconLandingWidget(
            Mdi.cat,
            "Proper color screens are not implemented yet~",
          ),
          RoundnessPage(),
          IconLandingWidget(
            Mdi.cat,
            "Shadow effects are not implemented yet~",
          ),
          FontsPage(),
        ],
      )
    );
  }
}