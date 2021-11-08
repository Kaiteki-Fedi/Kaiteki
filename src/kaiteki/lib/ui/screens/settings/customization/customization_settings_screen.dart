import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kaiteki/ui/pages/customization/customization_basic_page.dart';

class CustomizationSettingsScreen extends StatefulWidget {
  const CustomizationSettingsScreen({Key? key}) : super(key: key);

  @override
  _CustomizationSettingsScreenState createState() =>
      _CustomizationSettingsScreenState();
}

class _CustomizationSettingsScreenState
    extends State<CustomizationSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsCustomization)),
      body: const CustomizationBasicPage(),
    );
  }
}
