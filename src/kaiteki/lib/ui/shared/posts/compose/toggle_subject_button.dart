import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';

class ToggleSubjectButton extends StatelessWidget {
  const ToggleSubjectButton({
    super.key,
    required this.value,
    this.onChanged,
  });

  final bool value;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();
    return IconButton(
      onPressed: onChanged,
      isSelected: value,
      icon: const Icon(Icons.short_text_rounded),
      tooltip: value
          ? l10n.subjectButtonLabelDisable
          : l10n.subjectButtonLabelEnable,
    );
  }
}
