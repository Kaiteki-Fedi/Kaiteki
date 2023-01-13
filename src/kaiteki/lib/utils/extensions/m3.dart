import "package:flutter/material.dart";

extension ThemeDataExtensions on ThemeData {
  ButtonStyle get filledButtonStyle {
    if (!useMaterial3) return const ButtonStyle();

    final colorScheme = this.colorScheme;
    return ElevatedButton.styleFrom(
      foregroundColor: colorScheme.onPrimary,
      backgroundColor: colorScheme.primary,
    ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0));
  }

  ButtonStyle get filledTonalButtonStyle {
    if (!useMaterial3) return const ButtonStyle();

    final colorScheme = this.colorScheme;
    return ElevatedButton.styleFrom(
      foregroundColor: colorScheme.onSecondaryContainer,
      backgroundColor: colorScheme.secondaryContainer,
    ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0));
  }
}
