import "package:flutter/material.dart";
import "package:kaiteki/ui/shared/posts/count_button.dart";

class CountButtons extends StatefulWidget {
  const CountButtons({super.key});

  @override
  State<CountButtons> createState() => _CountButtonsState();
}

class _CountButtonsState extends State<CountButtons> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100,
        height: 40,
        child: CountButton(
          icon: const Icon(Icons.favorite_outline_rounded),
          activeIcon: const Icon(Icons.favorite_rounded),
          activeColor: Colors.red,
          active: _active,
          onTap: () {
            setState(() {
              _active = !_active;
            });
          },
        ),
      ),
    );
  }
}
