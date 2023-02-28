import "package:flutter/material.dart";

class InstanceVettingBottomSheet extends StatelessWidget {
  final String instance;

  const InstanceVettingBottomSheet({super.key, required this.instance});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Column(
          children: [
            Text(
              instance,
            ),
          ],
        );
      },
    );
  }
}
