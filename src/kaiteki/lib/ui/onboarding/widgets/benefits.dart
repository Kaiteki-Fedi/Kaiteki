import "package:flutter/material.dart";

const _iconSize = 192.0;

List<UserBenefit> get benefits {
  return <UserBenefit>[
    UserBenefit(
      "Welcome to Kaiteki",
      "The comfy social-networking-site client for everything, everywhere.",
      () => Image.asset(
        "assets/icon.png",
        key: const ValueKey(0),
        width: _iconSize,
        height: _iconSize,
      ),
    ),
    UserBenefit(
      "One app for everything",
      "Kaiteki supports all kinds of devices and social media — ranging from Mastodon to Misskey, and from Windows to the Web.",
      () => const Icon(
        key: ValueKey(1),
        Icons.check_circle_outline_rounded,
        size: _iconSize,
      ),
    ),
    UserBenefit(
      "Multiple accounts",
      "Sign in with multiple accounts for each social media site.",
      () => const Icon(
        key: ValueKey(2),
        Icons.people_outline_rounded,
        size: _iconSize,
      ),
    ),
    UserBenefit(
      "Beautiful design",
      "Made with open-source magic, Material Design and attention to detail.",
      () => const Icon(
        key: ValueKey(3),
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
