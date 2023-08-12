import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";

class PlainTextScreen extends StatelessWidget {
  final String text;
  final Widget title;

  const PlainTextScreen(this.text, {super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: [
          IconButton(
            icon: const Icon(Icons.content_copy_rounded),
            tooltip: "Copy to clipoboard",
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Copied to clipboard"),
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          scrollDirection: Axis.horizontal,
          child: SelectableText(
            text,
            style: Theme.of(context).ktkTextTheme?.monospaceTextStyle ??
                DefaultKaitekiTextTheme(context).monospaceTextStyle,
          ),
        ),
      ),
    );
  }
}
