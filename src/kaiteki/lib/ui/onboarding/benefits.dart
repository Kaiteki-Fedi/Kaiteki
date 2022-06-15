import 'package:flutter/material.dart';
import 'package:kaiteki/constants.dart';

const _iconSize = 192.0;
List<UserBenefit> get benefits {
  return <UserBenefit>[
    UserBenefit(
      "Welcome to Kaiteki",
      appDescription,
      () => Image.asset(
        "assets/icon.png",
        key: const ValueKey(0),
        width: _iconSize,
        height: _iconSize,
      ),
    ),
    UserBenefit(
      "One app for everything",
      "Kaiteki supports all kinds of devices and social media — ranging from Twitter to the Fediverse and from Windows to the Web",
      // ignore: prefer_const_constructors, error G8388A750: Constant evaluation error
      () => Icon(
        key: const ValueKey(1),
        Icons.check_circle_outline_rounded,
        size: _iconSize,
      ),
    ),
    UserBenefit(
      "Multiple accounts",
      "Sign with more than one account for each of your social media",
      // ignore: prefer_const_constructors, error G8388A750: Constant evaluation error
      () => Icon(
        key: const ValueKey(2),
        Icons.people_outline_rounded,
        size: _iconSize,
      ),
    ),
    UserBenefit(
      "Made with love",
      "Open-source, designed with Material Design and care to attention",
      // ignore: prefer_const_constructors, error G8388A750: Constant evaluation error
      () => Icon(
        key: const ValueKey(3),
        Icons.favorite_rounded,
        size: _iconSize,
      ),
    ),
  ];
}

class UserBenefit {
  final String title;
  final String description;
  final Widget Function() buildIcon;

  UserBenefit(this.title, this.description, this.buildIcon);
}
