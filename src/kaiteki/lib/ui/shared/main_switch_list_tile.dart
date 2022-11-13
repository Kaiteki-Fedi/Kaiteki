import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';

/// **`MainSwitchListTile`** is a customized SwitchListTile, used as the main
/// switch of the page to enable or disable the preferences on the page.
///
/// A recreation of the [`MainSwitchBar` of the AOSP](https://cs.android.com/android/platform/superproject/+/master:frameworks/base/packages/SettingsLib/MainSwitchPreference/src/com/android/settingslib/widget/MainSwitchBar.java).
class MainSwitchListTile extends StatelessWidget {
  final Color? activeColor;
  final Color? activeTileColor;
  final Color? tileColor;
  final ValueChanged<bool>? onChanged;
  final bool value;
  final Widget? title;
  final EdgeInsets? contentPadding;

  const MainSwitchListTile({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.activeTileColor,
    this.tileColor,
    this.title,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeTileColor = this.activeTileColor ?? theme.colorScheme.secondary;
    final tileColor = this.tileColor ?? theme.colorScheme.surface;
    final contentPadding = this.contentPadding == null
        ? null
        : const EdgeInsets.only(left: 16, right: 16).add(this.contentPadding!);

    return SwitchListTile(
      tileColor: value ? activeTileColor : tileColor,
      activeColor: activeColor ?? theme.colorScheme.onPrimary,
      title: DefaultTextStyle.merge(
        style: value ? TextStyle(color: theme.colorScheme.onPrimary) : null,
        child: _buildTitle(context),
      ),
      value: value,
      onChanged: onChanged,
      contentPadding: contentPadding,
    );
  }

  Widget _buildTitle(BuildContext context) {
    if (title != null) return title!;

    final l10n = context.getL10n();
    return Text(
      value ? l10n.switchListTileTextOn : l10n.switchListTileTextOff,
    );
  }
}
