import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/material.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/utils/extensions.dart";

class UserBadge extends StatelessWidget {
  final String label;
  final Color color;

  const UserBadge(this.label, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    var color = Color.lerp(
      this.color,
      Theme.of(context).colorScheme.onBackground,
      0.5,
    )!;

    if (Theme.of(context).useMaterial3) {
      final palette = createCustomColorPalette(
        color.harmonizeWith(Theme.of(context).colorScheme.primary),
        Theme.of(context).colorScheme.brightness,
      );

      color = palette.color;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: color),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        child: Text(
          label.toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .labelSmall
              .fallback
              .copyWith(color: color),
        ),
      ),
    );
  }
}

class AdministratorUserBadge extends StatelessWidget {
  const AdministratorUserBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserBadge("Admin", Colors.red);
  }
}

class ModeratorUserBadge extends StatelessWidget {
  const ModeratorUserBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserBadge("Mod", Colors.blue);
  }
}

class BotUserBadge extends StatelessWidget {
  const BotUserBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserBadge("Bot", Colors.blueGrey);
  }
}
