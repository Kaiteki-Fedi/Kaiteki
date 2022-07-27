import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/ui/settings/customization/customization_basic_page.dart';

class CustomizationSettingsScreen extends StatefulWidget {
  const CustomizationSettingsScreen({super.key});

  @override
  State<CustomizationSettingsScreen> createState() =>
      _CustomizationSettingsScreenState();
}

class _CustomizationSettingsScreenState
    extends State<CustomizationSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsCustomization)),
      body: const CustomizationBasicPage(),
    );
  }
}
