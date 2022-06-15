import 'package:flutter/material.dart';

extension ThemeDataExtensions on ThemeData {
  ButtonStyle get filledButtonStyle {
    if (!useMaterial3) return const ButtonStyle();

    final colorScheme = this.colorScheme;
    return ElevatedButton.styleFrom(
      onPrimary: colorScheme.onPrimary,
      primary: colorScheme.primary,
    ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0));
  }

  ButtonStyle get filledTonalButtonStyle {
    if (!useMaterial3) return const ButtonStyle();

    final colorScheme = this.colorScheme;
    return ElevatedButton.styleFrom(
      onPrimary: colorScheme.onSecondaryContainer,
      primary: colorScheme.secondaryContainer,
    ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0));
  }
}
