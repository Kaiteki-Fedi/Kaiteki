import 'package:flutter/material.dart';
import 'package:kaiteki/ui/widgets/separator_text.dart';
import 'package:mdi/mdi.dart';

class SettingsScreen extends StatelessWidget {
  static var _sections = <_Section>[
    _Section(
      items: [
        const _SettingsItem(icon: Mdi.wrench, title: "General"),
        const _SettingsItem(icon: Mdi.account, title: "Profile"),
        const _SettingsItem(icon: Mdi.lock, title: "Security"),
        _SettingsItem(
          icon: Mdi.filter,
          title: "Filtering",
          onTap: (context) {
            Navigator.pushNamed(context, "/settings/filtering");
          },
        ),
        const _SettingsItem(
          icon: Mdi.bell,
          title: "Notifications",
        ),
        const _SettingsItem(
          icon: Mdi.download,
          title: "Data Import / Export",
        ),
        const _SettingsItem(
          icon: Mdi.eyeOff,
          title: "Mutes and Blocks",
        ),
      ],
    ),
    _Section(
      title: "Kaiteki Settings",
      items: [
        _SettingsItem(
          icon: Mdi.palette,
          title: "Customization",
          onTap: (context) {
            Navigator.pushNamed(context, "/settings/customization");
          },
        ),
        const _SettingsItem(
          icon: Mdi.tab,
          title: "Tabs",
        ),
      ],
    ),
    _Section(
      items: [
        _SettingsItem(
          icon: Mdi.information,
          title: "About",
          onTap: (c) => Navigator.pushNamed(c, "/about"),
        ),
        _SettingsItem(
          icon: Mdi.bug,
          title: "Debug and maintenance",
          onTap: (c) => Navigator.pushNamed(c, "/settings/debug"),
        )
      ],
    ),
  ];

  // GridView for desktop impl.
  List<Widget> _getListItems(BuildContext context, List<_Section> sections) {
    var widgets = <Widget>[];

    for (int i = 0; i < sections.length; i++) {
      if (i > 0) widgets.add(Divider());

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return ListView(children: _getListItems(context, _sections));
        },
      ),
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
