import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiteki/ui/onboarding/account_setup_page.dart';
import 'package:kaiteki/ui/onboarding/preferences_setup_page.dart';
import 'package:kaiteki/ui/onboarding/theme_setup_page.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

class SelfSelectScreen extends StatefulWidget {
  const SelfSelectScreen({super.key});

  @override
  State<SelfSelectScreen> createState() => _SelfSelectScreenState();
}

class _SelfSelectScreenState extends State<SelfSelectScreen> {
  var currentPage = 0;
  var previousPage = 0;
  bool get isLastPage => currentPage >= pages.length - 1;

  List<_SelfSelectPage> get pages {
    return [
      _SelfSelectPage(
        "Sign in to your accounts",
        "You need to be signed in to be able to use Kaiteki",
        AccountSetupPage.new,
      ),
      _SelfSelectPage(
        "Set preferences",
        "Make Kaiteki feel at home",
        PreferencesSetupPage.new,
      ),
      _SelfSelectPage(
        "Choose theme",
        "Select your favorite color scheme",
        ThemeSetupPage.new,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    const constraints = BoxConstraints(maxWidth: 360);
    final buttonStyle = TextButton.styleFrom();
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ConstrainedBox(
                constraints: constraints,
                child: PageTransitionSwitcher(
                  reverse: currentPage < previousPage,
                  transitionBuilder: (
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
                  },
                  child: Column(
                    key: ValueKey(currentPage),
                    children: [
                      const SizedBox(height: 12.0),
                      Text(
                        pages[currentPage].title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        pages[currentPage].subtitle,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      const SizedBox(height: 12.0),
                      Expanded(child: pages[currentPage].build()),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: constraints,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: currentPage > 0 ? onBackPressed : null,
                          icon: const Icon(Icons.chevron_left_rounded),
                          label: const Text("Back"),
                          style: buttonStyle,
                        ),
                        Flexible(
                          child: PageViewDotIndicator(
                            currentItem: currentPage,
                            count: pages.length,
                            unselectedColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.25),
                            selectedColor:
                                Theme.of(context).colorScheme.primary,
                            unselectedSize: const Size.square(8.0),
                            size: const Size.square(8.0),
                          ),
                        ),
                        Directionality(
                          textDirection: Directionality.of(context).inverted,
                          child: TextButton.icon(
                            onPressed:
                                isLastPage ? onFinishPressed : onNextPressed,
                            style: isLastPage
                                ? buttonStyle.merge(
                                    TextButton.styleFrom(
                                      primary: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                  )
                                : buttonStyle,
                            icon: isLastPage
                                ? const Icon(Icons.check_rounded, size: 20.0)
                                : const Icon(Icons.chevron_left_rounded),
                            label: isLastPage
                                ? const Text("Finish")
                                : const Text("Next"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onFinishPressed() {
    context.go("/");
  }

  void onNextPressed() {
    setState(() {
      previousPage = currentPage;
      currentPage = min(pages.length - 1, currentPage + 1);
    });
  }

  void onBackPressed() {
    setState(() {
      previousPage = currentPage;
      currentPage = max(0, currentPage - 1);
    });
  }
}

class _SelfSelectPage {
  final String title;
  final String subtitle;
  final Widget Function() build;

  _SelfSelectPage(this.title, this.subtitle, this.build);
}
