import "package:flutter/material.dart";

class HeaderSuggestionListTile extends StatelessWidget {
  const HeaderSuggestionListTile(this.text, {super.key});

  final Widget text;

  @override
  Widget build(BuildContext context) {
    final labelLarge = Theme.of(context).textTheme.labelLarge;
    return Semantics(
      header: true,
      child: ListTile(
        title: DefaultTextStyle.merge(
          style: labelLarge,
          child: text,
        ),
      ),
    );
  }
}
