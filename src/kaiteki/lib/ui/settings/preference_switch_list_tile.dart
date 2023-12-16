import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:notified_preferences/notified_preferences.dart";

class PreferenceSwitchListTile extends ConsumerWidget {
  final ChangeNotifierProvider<PreferenceNotifier<bool>> provider;
  final Widget? title;
  final Widget? subtitle;
  final Widget? secondary;
  final bool enabled;

  const PreferenceSwitchListTile({
    super.key,
    required this.provider,
    this.title,
    this.subtitle,
    this.secondary,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      secondary: secondary,
      title: title,
      subtitle: subtitle,
      onChanged: enabled ? (value) => ref.read(provider).value = value : null,
      value: ref.watch(provider).value,
    );
  }
}
