import 'package:flutter/material.dart';

class ToggleIconButton extends StatelessWidget {
  Color activeColor;
  bool value;
  Widget icon;

  ToggleIconButton(this.value, {this.activeColor});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: value ? activeColor : null,
      icon: icon,
      onPressed: () {  },
    );
  }
}
