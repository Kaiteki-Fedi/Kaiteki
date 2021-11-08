import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kaiteki/ui/widgets/separator_text.dart';
import 'package:mdi/mdi.dart';

class SettingsScreen extends StatelessWidget {
  List<_Section> _getItems(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return <_Section>[
      _Section(
        items: [
          _SettingsItem(icon: Mdi.wrench, title: l10n.settingsGeneral),
          _SettingsItem(icon: Mdi.account, title: l10n.settingsProfile),
          _SettingsItem(icon: Mdi.lock, title: l10n.settingsSecurity),
          _SettingsItem(
            icon: Mdi.filter,
            title: l10n.settingsFiltering,
            onTap: (context) {
              Navigator.pushNamed(context, "/settings/filtering");
            },
          ),
          _SettingsItem(icon: Mdi.bell, title: l10n.settingsNotifications),
          _SettingsItem(icon: Mdi.bell, title: l10n.settingsImportExport),
          _SettingsItem(icon: Mdi.eyeOff, title: l10n.settingsMutesBlocks),
        ],
      ),
      _Section(
        title: l10n.settingsKaiteki,
        items: [
          _SettingsItem(
            icon: Mdi.palette,
            title: l10n.settingsCustomization,
            onTap: (context) {
              Navigator.pushNamed(context, "/settings/customization");
            },
          ),
          _SettingsItem(icon: Mdi.tab, title: l10n.settingsTabs),
        ],
      ),
      _Section(
        items: [
          _SettingsItem(
            icon: Mdi.information,
            title: l10n.settingsAbout,
            onTap: (c) => Navigator.pushNamed(c, "/about"),
          ),
          _SettingsItem(
            icon: Mdi.bug,
            title: l10n.settingsDebugMaintenance,
            onTap: (c) => Navigator.pushNamed(c, "/settings/debug"),
          )
        ],
      ),
    ];
  }

  // GridView for desktop impl.
  List<Widget> _getListItems(BuildContext context, List<_Section> sections) {
    var widgets = <Widget>[];

    for (int i = 0; i < sections.length; i++) {
      if (i > 0) widgets.add(const Divider());

      var section = sections[i];

      if (section.hasTitleHeader) {
        widgets.add(SeparatorText(section.title!));
      }

      for (var item in section.items) {
        widgets.add(ListTile(
          leading: Icon(item.icon),
          title: Text(item.title),
          enabled: item.isEnabled,
          onTap: item.isEnabled ? () => item.onTap!.call(context) : null,
        ));
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final items = _getItems(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(children: _getListItems(context, items)),
    );
  }
}

class _Section {
  final String? title;
  final List<_SettingsItem> items;

  bool get hasTitleHeader => title != null;

  const _Section({this.title, required this.items});
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final Function(BuildContext context)? onTap;

  bool get isEnabled => onTap != null;

  const _SettingsItem({required this.icon, required this.title, this.onTap});
}
