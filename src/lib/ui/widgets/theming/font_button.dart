import 'package:flutter/material.dart';

class FontButton extends StatefulWidget {
  FontButton({Key key}) : super(key: key);

  @override
  _FontButtonState createState() => _FontButtonState();
}

class _FontButtonState extends State<FontButton> {
  String family = "Noto Sans";

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(family, style: TextStyle(
        fontFamily: family
      )),
      onPressed: () {

      },
    );
  }
}