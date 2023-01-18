import "package:flutter/material.dart";
import "package:kaiteki/theming/default/extensions.dart";

final birdDarkTheme = ThemeData.from(
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF1D9BF0),
    onPrimary: Colors.white,
    background: Color(0xFF15202B),
    surface: Color(0xFF1E2732),
    surfaceVariant: Color(0xFF1E2732),
    outlineVariant: Color(0xFF38444d),
    error: Color(0xFFF4212E),
    onError: Colors.white,
    secondary: Color(0xFF1D9BF0),
    onSecondary: Colors.white,
  ),
).addKaitekiExtensions().copyWith(
      appBarTheme: const AppBarTheme(elevation: 0, color: Color(0xFF15202B)),
      badgeTheme: const BadgeThemeData(
        backgroundColor: Color(0xFF1D9BF0),
        textColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF15202B),
        elevation: 0,
        showSelectedLabels: false,
      ),
    );

final catLightTheme = ThemeData.from(
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF86B300),
    background: Color(0xFFF9F9F9),
    secondary: Color(0xFF86B300),
    onSecondary: Colors.white,
  ),
).addKaitekiExtensions().copyWith(
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFFF9F9F9),
        foregroundColor: Colors.black,
      ),
      badgeTheme: const BadgeThemeData(
        backgroundColor: Color(0xFF86B300),
        textColor: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFFF9F9F9),
        selectedItemColor: const Color(0xFF676767),
        unselectedItemColor: const Color(0xFF676767).withOpacity(.7),
        elevation: 0,
        showSelectedLabels: false,
      ),
      iconTheme: IconThemeData(
        color: const Color(0xFF676767).withOpacity(.7),
      ),
    );
