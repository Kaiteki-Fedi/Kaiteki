import 'package:breakpoint/breakpoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/ui/settings/customization/customization_basic_page.dart';
import 'package:kaiteki/ui/settings/debug_page.dart';

enum SettingsCategory {
  customization(icon: Icons.palette_rounded),
  tabs(icon: Icons.tab_rounded),
  debug(icon: Icons.bug_report_rounded);

  final IconData icon;

  const SettingsCategory({
    required this.icon,
  });

  String getTitle(AppLocalizations l10n) {
    switch (this) {
      case SettingsCategory.customization:
        return l10n.settingsCustomization;
      case SettingsCategory.tabs:
        return l10n.settingsTabs;
      case SettingsCategory.debug:
        return l10n.settingsDebugMaintenance;
    }
  }

  Widget build(BuildContext context) {
    switch (this) {
      case SettingsCategory.customization:
        return const CustomizationBasicPage();
      case SettingsCategory.tabs:
        return const CustomizationBasicPage();
      case SettingsCategory.debug:
        return const DebugPage();
    }
  }
}

class SettingsScreen extends StatefulWidget {
  final SettingsCategory? category;

  const SettingsScreen({Key? key, this.category}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final l10n = context.getL10n();

    return BreakpointBuilder(
      builder: (context, breakpoint) {
        final isMobile = breakpoint.window <= WindowSize.xsmall;
        final category = widget.category;
        final isListVisible = !isMobile || category == null;
        return WillPopScope(
          onWillPop: () async {
            return true;
            // if (isListVisible) return true;
            // //setState(() => category = null);
            // context.go("/settings");
            // return false;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                isListVisible ? l10n.settings : category.getTitle(l10n),
              ),
            ),
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isListVisible)
                  isMobile
                      ? Flexible(child: _buildList(isMobile))
                      : SizedBox(width: 256, child: _buildList(isMobile)),
                if (!isMobile) const VerticalDivider(width: 1),
                if (category != null || !isMobile)
                  Expanded(
                    child: category == null //
                        ? const SizedBox()
                        : SingleChildScrollView(child: category.build(context)),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildList(bool isMobile) {
    final l10n = context.getL10n();
    return ListView.builder(
      itemBuilder: (context, index) {
        final category = SettingsCategory.values[index];
        return ListTile(
          leading: Icon(category.icon),
          title: Text(category.getTitle(l10n)),
          onTap: () {
            if (!isMobile) context.go("/settings/${category.name}");
          },
          selected: category == widget.category,
        );
      },
      itemCount: SettingsCategory.values.length,
    );
  }
}
