import "package:flutter/material.dart";

class DialogPage extends Page {
  final WidgetBuilder builder;

  const DialogPage({required this.builder});

  @override
  Route createRoute(BuildContext context) {
    return DialogRoute(
      builder: builder,
      context: context,
      settings: this,
    );
  }
}
