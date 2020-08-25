
import 'package:flutter/material.dart';
import 'package:kaiteki/ui/pages/customization/customization_advanced_page.dart';
import 'package:kaiteki/ui/pages/customization/customization_basic_page.dart';

class CustomizationSettingsScreen extends StatefulWidget {
  CustomizationSettingsScreen({Key key}) : super(key: key);

  @override
  _CustomizationSettingsScreenState createState() =>
      _CustomizationSettingsScreenState();
}

class _CustomizationSettingsScreenState
    extends State<CustomizationSettingsScreen>
    with SingleTickerProviderStateMixin {

  TabController _tabController;

  var _tabs = <Widget>[
    Tab(text: "BASIC"),
    Tab(text: "ADVANCED"),
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Customization"),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CustomizationBasicPage(),
          CustomizationAdvancedPage(),
        ],
      ),
    );
  }
}