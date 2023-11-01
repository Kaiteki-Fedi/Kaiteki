import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:kaiteki/ui/shared/dialogs/options_dialog.dart";
import "package:notified_preferences/notified_preferences.dart";

Widget defaultTextBuilder<T>(BuildContext context, T value) {
  return Text(value is Enum ? value.name : value.toString());
}

class PreferenceValuesListTile<T> extends ConsumerWidget {
  final ChangeNotifierProvider<PreferenceNotifier<T>> provider;
  final Widget? title;
  final List<T>? values;
  final Widget Function(BuildContext context, T value)? textBuilder;
  final Widget? leading;

  const PreferenceValuesListTile({
    super.key,
    required this.provider,
    this.title,
    this.values,
    this.textBuilder,
    this.leading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: leading,
      subtitle: buildText(context, ref.watch(provider).value),
      title: title,
      onTap: () => _onTap(context, ref),
    );
  }

  Widget buildText(BuildContext context, T value) {
    return (textBuilder ?? defaultTextBuilder)(context, value);
  }

  Future<void> _onTap(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(provider);
    final value = await showDialog<T>(
      context: context,
      builder: (context) => OptionsDialog.fromListTile(this, notifier.value),
    );

    if (value == null) return;

    notifier.value = value;
  }
}
