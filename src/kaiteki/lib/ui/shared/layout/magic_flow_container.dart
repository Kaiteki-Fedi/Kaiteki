import "dart:math";

import "package:flutter/material.dart";

class MagicFlowContainer extends StatelessWidget {
  final int maxColumns;
  final List<Widget> children;

  const MagicFlowContainer({
    super.key,
    required this.children,
    this.maxColumns = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < children.length; i += maxColumns)
          Expanded(child: buildRow(context, i)),
      ],
    );
  }

  Widget buildRow(BuildContext context, int i) {
    final columnCount = min(i + maxColumns, children.length);
    return Row(
      children: [
        for (var j = i; j < columnCount; j++) Expanded(child: children[j]),
      ],
    );
  }
}
