import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

class PanelWidget extends StatelessWidget {
  final Text title;
  final Widget child;

  const PanelWidget({Key key, this.title, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      child: Container(
        width: 375,
        child: Column(
          children: [
            DefaultTextStyle(
              style: theme.primaryTextTheme.subtitle1,
              child: Material(
                color: theme.primaryColor,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      title,
                      Spacer(),
                      IconButton(icon: Icon(Mdi.cat))
                    ],
                  ),
                ),
              ),
            ),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}
