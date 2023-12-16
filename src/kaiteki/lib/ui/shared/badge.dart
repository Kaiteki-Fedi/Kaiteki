import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/theme_preferences.dart";

/// Wrapper around [Badge] which respects user preferences.
class KtkBadge extends ConsumerWidget {
  final int? count;
  final Widget? child;
  final bool? showLabel;

  const KtkBadge({
    super.key,
    required this.count,
    this.child,
    this.showLabel,
  }) : assert(!((count == null || count < 1) && child == null));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = this.count;
    final showLabel = !(count == null || count < 1 || this.showLabel == false);

    if (!showLabel) return child!;

    if (ref.watch(showBadgeNumbers).value) {
      return Badge.count(
        count: count,
        child: child,
      );
    }

    return Badge(child: child);
  }
}
