import "package:collection/collection.dart";
import "package:flutter/material.dart";

class SettingsSection extends StatelessWidget {
  final Widget? title;
  final List<Widget> children;
  final bool useCard;
  final bool divideChildren;

  const SettingsSection({
    super.key,
    required this.children,
    this.title,
    this.useCard = true,
    this.divideChildren = true,
  });

  @override
  Widget build(BuildContext context) {
    const divider = Divider(indent: 16, endIndent: 16, height: 9);
    final title = this.title;

    final children = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: divideChildren
          ? this
              .children
              .expandIndexed((i, e) => [if (i != 0) divider, e])
              .toList()
          : this.children,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 8.0),
            child: title,
          ),
        if (useCard)
          Card(
            margin: const EdgeInsets.all(16.0),
            clipBehavior: Clip.antiAlias,
            child: children,
          )
        else
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: children,
          ),
      ],
    );
  }
}
