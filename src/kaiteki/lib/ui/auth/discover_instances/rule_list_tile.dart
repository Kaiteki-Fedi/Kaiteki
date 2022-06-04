import 'package:flutter/material.dart';

class RuleListTile extends StatelessWidget {
  const RuleListTile({
    Key? key,
    required this.number,
    required this.rule,
  }) : super(key: key);

  final int number;
  final String rule;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).disabledColor,
        radius: 12.0,
        child: Text(
          number.toString(),
          textScaleFactor: 0.85,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(rule),
      dense: true,
    );
  }
}
