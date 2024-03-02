import "package:async/async.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/ui/onboarding/widgets/benefits.dart";

const _slideDuration = Duration(seconds: 5);

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _UserBenefits()),
          const SizedBox(height: 16.0),
          Center(
            child: FilledButton.icon(
              onPressed: () => context.push("/onboarding/account-setup"),
              icon: const Icon(Icons.chevron_right_rounded),
              iconAlignment: IconAlignment.end,
              label: const Text("Get Started"),
              style: FilledButton.styleFrom(
                visualDensity: VisualDensity.standard,
              ),
              autofocus: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserBenefits extends StatefulWidget {
  @override
  State<_UserBenefits> createState() => _UserBenefitsState();
}

class _UserBenefitsState extends State<_UserBenefits> {
  late final RestartableTimer timer;
  int _currentPage = 0;

  bool get isLastPage => _currentPage >= benefits.length - 1;

  bool get isFirstPage => _currentPage <= 0;

  UserBenefit get currentBenefit => benefits[_currentPage];

  @override
  void initState() {
    super.initState();
    timer = RestartableTimer(
      _slideDuration,
      () {
        setState(() => _currentPage = isLastPage ? 0 : _currentPage + 1);
        timer.reset();
      },
    )..reset();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: AnimatedSwitcher(
        duration: Durations.medium1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          key: ValueKey(_currentPage),
          children: [
            Text(
              currentBenefit.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8.0),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 96),
              child: Text(
                currentBenefit.description,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap() {
    timer.reset();
    setState(() => _currentPage = isLastPage ? 0 : _currentPage + 1);
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
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
  }
}
