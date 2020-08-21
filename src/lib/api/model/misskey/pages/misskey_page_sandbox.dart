
import 'package:flutter/material.dart';
import 'package:kaiteki/api/model/misskey/pages/components/misskey_page_component.dart';
import 'package:kaiteki/api/model/misskey/pages/misskey_page.dart';

/// A sandbox for Misskey pages.
class MisskeyPageSandbox {
  final MisskeyPage page;
  final Map<String, dynamic> variables = <String, dynamic>{};

  final Function() onRebuildRequired;
  
  MisskeyPageSandbox(this.page, {this.onRebuildRequired});

  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var component in this.page.content)
          getComponent(context, component),
      ],
    );
  }

  Widget getComponent(BuildContext context, MisskeyPageComponent component) {
    switch (component.type) {
      case "text":
        return buildText(context, component);

      case "counter":
        return buildCounter(context, component);
      default: return Placeholder();
    }
  }

  Widget buildText(BuildContext context, MisskeyPageComponent component) {
    return Text(component.text);
  }

  Widget buildCounter(BuildContext context, MisskeyPageComponent component) {
    return RaisedButton(
      child: Text(component.text),
      onPressed: () {
        var variable = component.raw["name"] as String;

        if (!variables.containsKey(variable))
          variables[variable] = 0;

        variables[variable]++;

        onRebuildRequired.call();
      },
    );
  }
}