import "package:flutter/material.dart";

class UserBadge extends StatelessWidget {
  final String label;
  final Color color;

  const UserBadge(this.label, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withOpacity(0.25),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4.0,
          vertical: 2.0,
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: DefaultTextStyle.of(context).style.fontSize! * 0.8,
          ),
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
