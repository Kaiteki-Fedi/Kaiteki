import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// TODO:  Provide defaults of widgets being used (Icon, Text) and give the user
//       flexibility of using other widgets.
class IconLandingWidget extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconLandingWidget({this.icon, this.text, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: theme.dividerColor,
          size: 96,
        ),
        Text(
          text,
          style: TextStyle(
              color: theme.textTheme.bodyText1.color.withOpacity(.75),
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
