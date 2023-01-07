import 'package:flutter/material.dart';
import 'package:kaiteki/theming/default/colors.dart'
    show kaitekiOrange, kaitekiPink;
import 'package:kaiteki/ui/settings/about/app_name_badge.dart';

enum AppBadgeKind {
  alpha("Alpha", kaitekiPink, Colors.white),
  beta("Beta", kaitekiOrange, Colors.black),
  debug("Debug", Color(0xFFB71C1C), Colors.white);

  final Color foregroundColor;
  final Color backgroundColor;
  final String text;

  const AppBadgeKind(this.text, this.backgroundColor, this.foregroundColor);

  // ignore: use_to_and_as_if_applicable
  AppNameBadge build() => AppNameBadge(this);
}
