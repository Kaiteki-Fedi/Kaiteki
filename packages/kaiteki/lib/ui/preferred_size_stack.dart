import "package:flutter/widgets.dart";

class PreferredSizeStack extends StatelessWidget
    implements PreferredSizeWidget {
  final PreferredSizeWidget primary;
  final Widget? bottom;

  const PreferredSizeStack({
    super.key,
    required this.primary,
    required this.bottom,
  });

  @override
  Size get preferredSize => primary.preferredSize;

  @override
  Widget build(BuildContext context) {
    final bottom = this.bottom;
    return Stack(
      children: [
        if (bottom != null) Positioned.fill(child: bottom),
        primary,
      ],
    );
  }
}
