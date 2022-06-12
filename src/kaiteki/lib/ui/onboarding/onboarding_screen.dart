import 'package:animations/animations.dart';
import 'package:async/async.dart';
import 'package:breakpoint/breakpoint.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/ui/onboarding/benefits.dart';
import 'package:kaiteki/ui/onboarding/self_select_screen.dart';
import 'package:kaiteki/utils/extensions/m3.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

const transitionDuration = Duration(milliseconds: 800);
const pageDuration = Duration(seconds: 5);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final RestartableTimer timer;
  int _currentPage = 0;
  bool get isLastPage => _currentPage >= benefits.length - 1;
  UserBenefit get currentBenefit => benefits[_currentPage];

  @override
  void initState() {
    super.initState();

    final timerDuration = pageDuration + transitionDuration;
    timer = RestartableTimer(
      timerDuration,
      () => setState(() => _currentPage = isLastPage ? 0 : _currentPage + 1),
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

    return Scaffold(
      body: BreakpointBuilder(
        builder: (context, breakpoint) {
            return breakpoint.window >= WindowSize.medium ?  buildLandscape():buildPortrait();
        },
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
                    closedBuilder: (_, callback) => ElevatedButton(
                      onPressed: callback,
                      style: Theme.of(context).filledTonalButtonStyle,
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
    child,
    animation,
    secondaryAnimation,
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
              OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                tappable: false,
                transitionDuration: const Duration(milliseconds: 600),
                closedShape: const StadiumBorder(),
                closedColor: Theme.of(context).colorScheme.secondaryContainer,
                closedBuilder: (_, callback) => ElevatedButton(
                  onPressed: callback,
                  style: Theme.of(context).filledTonalButtonStyle,
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

class _UserBenefitText extends StatelessWidget {
  final UserBenefit benefit;
  final bool center;

  const _UserBenefitText({
    Key? key,
    required this.benefit,
    this.center = true,
  }) : super(key: key);

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
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8.0),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 96),
            child: Text(
              benefit.description,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          )
        ],
      ),
    );
  }
}
