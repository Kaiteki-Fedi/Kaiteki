import 'package:flutter/material.dart';

/// A Material Design subheader.
///
/// Subheaders are list tiles that delineate sections of a list or grid list.
///
/// See also:
///
/// - https://m1.material.io/components/subheaders.html
class Subheader extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const Subheader(
    this.child, {
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final labelLarge = theme.textTheme.labelLarge;
    final primary = theme.colorScheme.primary;
    final textStyle = labelLarge!.copyWith(color: primary);

    return Semantics(
      header: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: padding,
            child: DefaultTextStyle.merge(style: textStyle, child: child),
          ),
        ),
      ),
    );
  }
}
