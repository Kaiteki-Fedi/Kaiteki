import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/l10n/localizations.dart";
import "package:kaiteki/ui/shared/common.dart";

class UserBadge extends StatelessWidget {
  final UserBadgeType type;

  const UserBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    var color = type.color;

    if (type.color != null) {
      final palette = createCustomColorPalette(
        color!.harmonizeWith(Theme.of(context).colorScheme.primary),
        Theme.of(context).colorScheme.brightness,
      );

      color = palette.color;
    }

    return Tooltip(
      message: type.getLabel(context.l10n),
      child: Icon(type.icon, color: color),
    );
  }
}

enum UserBadgeType {
  administrator(Icons.health_and_safety_rounded, Colors.redAccent),
  moderator(Icons.shield_rounded, Colors.orangeAccent),
  bot(Icons.smart_toy_rounded, Colors.blueAccent);

  final Color? color;
  final IconData icon;

  const UserBadgeType(this.icon, [this.color]);

  String getLabel(KaitekiLocalizations l10n) {
    return switch (this) {
      UserBadgeType.administrator =>
        "Administrator", // l10n.userBadgeAdministrator,
      UserBadgeType.moderator => "Moderator", // l10n.userBadgeModerator,
      UserBadgeType.bot => "Bot", // l10n.userBadgeBot,
    };
  }
}
