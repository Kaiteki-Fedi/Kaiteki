import "package:flutter/material.dart";
import "package:kaiteki/theming/text_theme.dart";
import "package:kaiteki/ui/onboarding/widgets/lava_lamp.dart";
import "package:kaiteki/ui/window_class.dart";

import "widgets/alpha_disclaimer.dart";

class OnboardingScreen extends StatelessWidget {
  final Widget child;

  const OnboardingScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _OnboardingContainer(child: child),
    );
  }
}

class _OnboardingContainer extends StatelessWidget {
  final Widget child;

  const _OnboardingContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).height < 600) {
      return _buildNarrow(context);
    }

    final windowClass = WindowClass.fromContext(context);
    if (windowClass >= WindowClass.medium) {
      return _buildLandscape(context);
    }

    return _buildPortrait(context);
  }

  Widget _buildPortrait(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 256,
          child: Stack(
            children: [
              Positioned.fill(
                child: _LavaLamp(),
              ),
              Center(child: _AppTitle()),
            ],
          ),
        ),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildNarrow(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Stack(
            children: [
              Positioned.fill(child: _LavaLamp()),
              Positioned(
                left: 32,
                top: 0,
                bottom: 0,
                child: Center(child: _AppTitle()),
              ),
              Positioned(
                left: 32,
                bottom: 32,
                right: 32,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: AlphaDisclaimer(),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Material(child: child),
        ),
      ],
    );
  }

  Widget _buildLandscape(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: _LavaLamp()),
        Center(
          child: Column(
            children: [
              const Flexible(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: _AppTitle(),
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Card(
                  elevation: 8.0,
                  surfaceTintColor: Colors.transparent,
                  shadowColor: Theme.of(context).colorScheme.shadow,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 512),
                    child: child,
                  ),
                ),
              ),
              const Flexible(
                child: Center(child: AlphaDisclaimer()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LavaLamp extends StatelessWidget {
  const _LavaLamp();

  @override
  Widget build(BuildContext context) {
    switch (Theme.of(context).brightness) {
      case Brightness.light:
        return const LavaLamp(
          color1: Color(0xFFFFDDB8),
          color2: Color(0xFFFFB2BC),
        );
      case Brightness.dark:
        return const LavaLamp(
          color1: Color(0xFF5E411C),
          color2: Color(0xFF871C37),
        );
    }
  }
}

class _AppTitle extends StatelessWidget {
  const _AppTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      // ignore: l10n
      "Kaiteki",
      style: Theme.of(context).textTheme.titleLarge?.merge(
            Theme.of(context).ktkTextTheme?.kaitekiTextStyle ??
                DefaultKaitekiTextTheme(context).kaitekiTextStyle,
          ),
    );
  }
}
