import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:kaiteki/ui/settings/about/app_badge_kind.dart";

class AppNameBadge extends StatelessWidget {
  final AppBadgeKind kind;

  const AppNameBadge(this.kind, {super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: kind.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          kind.name.toUpperCase(),
          style: GoogleFonts.robotoMono(
            color: kind.foregroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
