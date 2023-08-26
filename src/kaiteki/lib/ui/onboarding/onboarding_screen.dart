import "package:animations/animations.dart";
import "package:async/async.dart";
import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:kaiteki/ui/onboarding/benefits.dart";
import "package:kaiteki/ui/onboarding/self_select_screen.dart";
import "package:kaiteki/ui/window_class.dart";
import "package:page_view_dot_indicator/page_view_dot_indicator.dart";
import "package:url_launcher/url_launcher.dart";

const transitionDuration = Duration(milliseconds: 800);
const pageDuration = Duration(seconds: 5);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final RestartableTimer timer;
  int _currentPage = 0;
  bool get isLastPage => _currentPage >= benefits.length - 1;
  bool get isFirstPage => _currentPage <= 0;
  UserBenefit get currentBenefit => benefits[_currentPage];

  @override
  void initState() {
    super.initState();

    const timerDuration = pageDuration;
    timer = RestartableTimer(
      timerDuration,
      () {
        setState(() => _currentPage = isLastPage ? 0 : _currentPage + 1);
        timer.reset();
      },
    );
    timer.reset();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) return const SizedBox();

    return GestureDetector(
      onTap: () {
        timer.reset();
        setState(() => _currentPage = isLastPage ? 0 : _currentPage + 1);
      },
      onHorizontalDragEnd: (details) {
        // Swiping in right direction.
        if (details.primaryVelocity! < -5) {
          timer.reset();
          setState(() => _currentPage = isLastPage ? 0 : _currentPage + 1);
        }

        // Swiping in left direction.
        if (details.primaryVelocity! > 5) {
          timer.reset();
          setState(() {
            _currentPage = isFirstPage ? benefits.length - 1 : _currentPage - 1;
          });
        }
      },
      child: Scaffold(
        body: WindowClass.fromContext(context) >= WindowClass.medium
            ? buildLandscape()
            : buildPortrait(),
      ),
    );
  }

  Widget buildPortrait() {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: PageTransitionSwitcher(
                      duration: transitionDuration,
                      transitionBuilder: buildHorizontalSharedAxisTransition,
                      child: Column(
                        key: ValueKey(_currentPage),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          currentBenefit.buildIcon(),
                          const SizedBox(height: 24.0),
                          _UserBenefitText(benefit: currentBenefit),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: OpenContainer(
                    transitionType: ContainerTransitionType.fadeThrough,
                    tappable: false,
                    transitionDuration: const Duration(milliseconds: 600),
                    closedShape: const StadiumBorder(),
                    closedColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    closedBuilder: (_, callback) => FilledButton.tonal(
                      onPressed: callback,
                      child: const Text("Get started"),
                    ),
                    openBuilder: (_, action) => const SelfSelectScreen(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: buildPageIndicator(true),
          ),
        ],
      ),
    );
  }

  Widget buildHorizontalSharedAxisTransition(
    Widget child,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return SharedAxisTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      transitionType: SharedAxisTransitionType.horizontal,
      child: child,
    );
  }

  Widget buildLandscape() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: PageTransitionSwitcher(
            duration: transitionDuration,
            transitionBuilder: buildHorizontalSharedAxisTransition,
            child: benefits[_currentPage].buildIcon(),
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: transitionDuration,
                child: _UserBenefitText(
                  benefit: currentBenefit,
                  key: ValueKey(_currentPage),
                  center: false,
                ),
              ),
              const AlphaDisclaimer(),
              const SizedBox(height: 24.0),
              OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                tappable: false,
                transitionDuration: const Duration(milliseconds: 600),
                closedShape: const StadiumBorder(),
                closedColor: Theme.of(context).colorScheme.secondaryContainer,
                closedBuilder: (_, callback) => FilledButton.tonal(
                  onPressed: callback,
                  child: const Text("Get started"),
                ),
                openBuilder: (_, action) => const SelfSelectScreen(),
              ),
              const SizedBox(height: 24.0),
              buildPageIndicator(false),
            ],
          ),
        ),
      ],
    );
  }

  // ignore: avoid_positional_boolean_parameters
  Widget buildPageIndicator(bool center) {
    return PageViewDotIndicator(
      currentItem: _currentPage,
      count: benefits.length,
      unselectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.25),
      selectedColor: Theme.of(context).colorScheme.primary,
      unselectedSize: const Size.square(8.0),
      size: const Size.square(8.0),
      alignment: center ? Alignment.center : Alignment.centerLeft,
      padding: EdgeInsets.zero,
      fadeEdges: false,
    );
  }
}

class AlphaDisclaimer extends StatelessWidget {
  const AlphaDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cautionColor = ColorScheme.fromSeed(
      seedColor: Colors.amberAccent,
      brightness: theme.brightness,
    ).primary.harmonizeWith(theme.colorScheme.primary);
    return Row(
      children: [
        Icon(Icons.warning_rounded, color: cautionColor),
        const SizedBox(width: 8.0),
        Text.rich(
          style: TextStyle(color: cautionColor, height: 1.35),
          TextSpan(
            children: [
              const TextSpan(text: "Kaiteki is "),
              const TextSpan(
                text: "alpha",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: " software. "),
              TextSpan(
                text: "What does this mean?",
                style: const TextStyle(decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    final url = Uri.parse("");
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UserBenefitText extends StatelessWidget {
  final UserBenefit benefit;
  final bool center;

  const _UserBenefitText({
    super.key,
    required this.benefit,
    this.center = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Column(
        crossAxisAlignment:
            center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            benefit.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8.0),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 96),
            child: Text(
              benefit.description,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
