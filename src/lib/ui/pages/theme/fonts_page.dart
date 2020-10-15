import 'package:flutter/material.dart';
import 'package:kaiteki/ui/widgets/theming/font_button.dart';
import 'package:kaiteki/ui/widgets/separator_text.dart';

class FontsPage extends StatefulWidget {
  FontsPage({Key key}) : super(key: key);

  @override
  _FontsPageState createState() => _FontsPageState();
}

class _FontsPageState extends State<FontsPage> {
  @override
  Widget build(BuildContext context) {
    var buttonPadding = const EdgeInsets.symmetric(horizontal: 16);

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SeparatorText("Interface"),
        ),
        Padding(
          padding: buttonPadding,
          child: FontButton(),
        ),

        Divider(),

        SeparatorText("Input fields"),
        Padding(
          padding: buttonPadding,
          child: FontButton(),
        ),

        Divider(),

        SeparatorText("Post text"),
        Padding(
          padding: buttonPadding,
          child: FontButton(),
        ),

        Divider(),

        SeparatorText("Monospaced text"),
        Padding(
          padding: buttonPadding,
          child: FontButton(),
        ),

        Divider(),

        ListTile(
          title: Text("Kaiteki supports Google Fonts"),
          subtitle: Text("Enter a name of a font from Google Fonts and Kaiteki will fetch and display it."),
        )
      ],
    );
  }
}