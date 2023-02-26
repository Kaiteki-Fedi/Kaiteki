import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:material_color_utilities/material_color_utilities.dart";

export "package:kaiteki/common.dart";

const centeredCircularProgressIndicator = Center(
  child: CircularProgressIndicator(),
);

Future<void> showTextAlert(BuildContext context, String title, String body) {
  return showDialog(
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          child: Text(context.materialL10n.okButtonLabel),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
    context: context,
  );
}

extension ColorKaitekiExtension on Color {
  TextStyle get textStyle => TextStyle(color: this);
}

double getLocalFontSize(BuildContext context) {
  return DefaultTextStyle.of(context).style.fontSize!;
}

Color getLocalTextColor(BuildContext context) {
  return DefaultTextStyle.of(context).style.color!;
}

CustomColorPalette createCustomColorPalette(
  Color color,
  Brightness brightness,
) {
  final hct = Hct.fromInt(color.value);
  final palette = TonalPalette.of(hct.hue, hct.chroma);
  return brightness == Brightness.light
      ? CustomColorPalette.fromLight(palette)
      : CustomColorPalette.fromDark(palette);
}

class CustomColorPalette {
  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;

  CustomColorPalette(
    this.color,
    this.onColor,
    this.colorContainer,
    this.onColorContainer,
  );

  factory CustomColorPalette.fromLight(TonalPalette palette) {
    return CustomColorPalette(
      Color(palette.get(40)),
      Color(palette.get(100)),
      Color(palette.get(90)),
      Color(palette.get(10)),
    );
  }

  factory CustomColorPalette.fromDark(TonalPalette palette) {
    return CustomColorPalette(
      Color(palette.get(80)),
      Color(palette.get(20)),
      Color(palette.get(30)),
      Color(palette.get(90)),
    );
  }
}
