import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/ui/shared/separator_text.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  List<_Section> _getItems(BuildContext context) {
    final l10n = context.getL10n();
    return <_Section>[
      _Section(
        items: [
          _SettingsItem(
            icon: Icons.build_rounded,
            title: l10n.settingsGeneral,
          ),
          _SettingsItem(
            icon: Icons.person_rounded,
            title: l10n.settingsProfile,
          ),
          _SettingsItem(
            icon: Icons.lock_rounded,
            title: l10n.settingsSecurity,
          ),
          _SettingsItem(
            icon: Icons.filter_alt_rounded,
            title: l10n.settingsFiltering,
            onTap: (context) => context.push("/settings/filtering"),
          ),
          _SettingsItem(
            icon: Icons.notifications_rounded,
            title: l10n.settingsNotifications,
          ),
          _SettingsItem(
            icon: Icons.import_export_rounded,
            title: l10n.settingsImportExport,
          ),
          _SettingsItem(
            icon: Icons.visibility_off_rounded,
            title: l10n.settingsMutesBlocks,
          ),
        ],
      ),
      _Section(
        title: l10n.settingsKaiteki,
        items: [
          _SettingsItem(
            icon: Icons.palette_rounded,
            title: l10n.settingsCustomization,
            onTap: (context) => context.push("/settings/customization"),
          ),
          _SettingsItem(icon: Icons.tab_rounded, title: l10n.settingsTabs),
        ],
      ),
      _Section(
        items: [
          _SettingsItem(
            icon: Icons.bug_report_rounded,
            title: l10n.settingsDebugMaintenance,
            onTap: (context) => context.push("/settings/debug"),
          )
        ],
      ),
    ];
  }

  // GridView for desktop impl.
  List<Widget> _getListItems(BuildContext context, List<_Section> sections) {
    final widgets = <Widget>[];

    for (var i = 0; i < sections.length; i++) {
      if (i > 0) widgets.add(const Divider());

      final section = sections[i];

      if (section.hasTitleHeader) {
        widgets.add(SeparatorText(section.title!));
      }

      for (final item in section.items) {
        widgets.add(
          ListTile(
            leading: Icon(item.icon),
            title: Text(item.title),
            enabled: item.isEnabled,
            onTap: item.isEnabled ? () => item.onTap!.call(context) : null,
          ),
        );
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final items = _getItems(context);
    final l10n = context.getL10n();

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
