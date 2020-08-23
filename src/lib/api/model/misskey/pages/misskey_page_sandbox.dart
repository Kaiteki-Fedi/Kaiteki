
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kaiteki/api/model/misskey/pages/components/misskey_page_component.dart';
import 'package:kaiteki/api/model/misskey/pages/misskey_page.dart';
import 'package:kaiteki/ui/widgets/misskey_page_post_widget.dart';
import 'package:kaiteki/utils/logger.dart';

/// A sandbox for Misskey pages.
class MisskeyPageSandbox {
  final MisskeyPage page;
  final Map<String, dynamic> variables = <String, dynamic>{};

  final Function() onRebuildRequired;
  
  MisskeyPageSandbox(this.page, {this.onRebuildRequired});

  Widget build(BuildContext context) {
    var widgets = this.page.content
      .map<Widget>((c) => getComponent(context, c))
      .where((w) => w != null)
      .toList(growable: false);

    return Column(children: widgets);
  }

  String interpolateText(String input) {
    var regex = RegExp("{(.+?)}");

    while (true) {
      var match = regex.firstMatch(input);

      // all matches were replaced or no were found
      if (match == null)
        break;

      var matchString = match.group(0);
      var variableName = matchString.substring(1, matchString.length - 1);
      var variableValue = "NULL";
      if (variables.containsKey(variableName))
        variableValue = variables[variableName].toString();

      input = input.replaceRange(match.start, match.end, variableValue);
    }

    return input;
  }

  Widget getComponent(BuildContext context, MisskeyPageComponent component) {
    switch (component.type) {
      case "text":
        return buildText(context, component);

      case "counter":
        return buildCounter(context, component);

      case "post": {
        var text = interpolateText(component.text);
        return MisskeyPagePostWidget(text);
      }

      case "if": {
        var name = component.raw["var"] as String;
        var isTrue = getVariable(name) as bool;

        // construct actual component if condition is true.
        if (isTrue) {
          var widgets = component.raw["children"]
            .map<MisskeyPageComponent>((j) => MisskeyPageComponent.fromJson(j))
            .map<Widget>((c) => getComponent(context, c))
            .toList(growable: false);

          return Column(children: widgets);
        }

        return null;
      }

      default:
        return Stack(
          children: [
            Placeholder(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Unsupported page type: ${component.type}\n${jsonEncode(component.raw)}"),
            )
          ],
        );
    }
  }

  dynamic getVariable(String name) {
    var variables = page.variables;
    var variable = variables
        .firstWhere((v) => v.raw["name"] as String == name);

    Iterable<dynamic> finalArgs;
    if (variable.raw["args"] != null) {
      finalArgs =
        (
          variable.raw["args"]
          .map<MisskeyPageComponent>((a) => MisskeyPageComponent.fromJson(a))
          as Iterable<MisskeyPageComponent>
        )
        .map((a) => resolveValue(a));
    }

    switch (variable.type) {
      case "gt": {
        var a = finalArgs.elementAt(0);
        var b = finalArgs.elementAt(1);
        var isNull = a == null || b == null;
        return !isNull && a > b;
      }
    }

    throw "${variable.type} not supported.";
  }

  dynamic resolveValue(MisskeyPageComponent component) {
    switch (component.type) {
      case "ref": {
        var value = component.raw["value"] as String;

        if (variables.containsKey(value))
          return variables[value];

        return null;
      }
      case "number": return int.parse(component.raw["value"] as String);
      default: return null;
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

        Logger.info("[Misskey Pages] counter has increased variable $variable to ${variables[variable]}");

        onRebuildRequired.call();
      },
    );
  }
}