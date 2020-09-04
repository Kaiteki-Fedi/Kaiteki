import 'package:flutter/material.dart';
import 'package:kaiteki/theming/app_theme.dart';
import 'package:kaiteki/theming/app_theme_convertible.dart';
import 'package:kaiteki/utils/string_extensions.dart';
import 'package:kaiteki/utils/utils.dart';
import 'package:supercharged/supercharged.dart';

class PleromaTheme extends AppThemeConvertible {
  Map<String, Color> colors;
  Map<String, double> opacities;
  Map<String, double> radii;
  String name;

  PleromaTheme.fromJson(Map<String, dynamic> json) {
    name = json["name"];

    var theme = json["theme"] ?? json["source"];

    opacities = theme["opacity"].map<String, double>((String k, v) {
      if (v is int) return MapEntry(k, v.toDouble());
      else return MapEntry(k, v as double);
    });
    colors = workOutColors(Map<String, String>.from(theme["colors"]));
    radii = theme["radii"].map<String, double>((String k, v) {
      if (v is String) return MapEntry(k, double.parse(v));
      if (v is int) return MapEntry(k, v.toDouble());
      else throw "Can't handle type";
    });
    //colors = 
  }

  double getOpacity(String opacityKey) {
    if (opacityKey == null)
      return 1;

    if (opacities.containsKey(opacityKey))
      return opacities[opacityKey];

    print("Couldn't find the opacity for key $opacityKey, defaulting to 1.");
    return 1;
  }

  Color getColor(String key) {
    if (colors.containsKey(key))
      return colors[key];

    return null;
  }

  /// This function solves all color dependencies as usually found in Pleroma-FE
  Map<String, Color> workOutColors(Map<String, String> input) {
    var output = <String, Color>{};



    Color get(String key, String fallback, {String opacityKey}) {
      var opacity = getOpacity(opacityKey);

      if (input.containsKey(key))
        if (input[key].substring(0, 2) == "--")
          return output[key.substring(2)];
        else
          return toColor(input[key]).withOpacity(opacity);

      if (output.containsKey(fallback))
        return output[fallback];

      throw "$key";
    }

    output["bg"] = toColor(input["bg"]).withOpacity(getOpacity("bg"));
    output["fg"] = toColor(input["fg"]);
    output["text"] = toColor(input["text"]);
    // output["underlay"] = toColor(input["underlay"]);
    if (input.containsKey("accent"))
      output["accent"] = toColor(input["accent"]);

    if (input.containsKey("link"))
      output["link"] = toColor(input["link"]);

    if (output["link"] == null)
      output["link"] = output["accent"];

    if (output["accent"] == null)
      output["accent"] = output["link"];

    output["cBlue"] = toColor(input["cBlue"]);
    output["cRed"] = toColor(input["cRed"]);
    output["cGreen"] = toColor(input["cGreen"]);
    output["cOrange"] = toColor(input["cOrange"]);

    output["border"] = get("border", "fg");
    output["fgText"] = get("fgText", "text");
    output["fgLink"] = get("fgLink", "link");

    // Panel header
    output["panelText"] = get("panelText", "text");

    // Highlight
    output["highlightText"] = get("highlightText", "text");


    // Top bar
    output["topBar"] = get("topBar", "fg");
    output["topBarText"] = get("topBarText", "fgText");
    output["topBarLink"] = get("topBarLink", "fgLink");

    // Alert
    output["alertError"] = get("alertError", "cRed");
    output["alertErrorText"] = get("alertErrorText", "text");
    output["alertErrorPanelText"] = get("alertErrorPanelText", "panelText");

    // Buttons
    output["btn"] = get("btn", "fg");
    output["btnText"] = get("btnText", "fgText");
    output["btnDisabled"] = get("btnDisabled", "btn"); // alphaBlend(btn, 0.25, bg)

    // Menu
    output["selectedMenu"] = get("selectedMenu", "bg"); // brightness(5 * mod, bg).rgb
    output["selectedMenuText"] = get("selectedMenuText", "highlightText");
    output["selectedMenuIcon"] = get("selectedMenuIcon", "selectedMenuText"); // mixrgb(bg, text)

    // Popover
    output["popover"] = get("popover", "bg");
    output["popoverText"] = get("popoverText", "text");

    // Chat
    output["chatBg"] = get("chatBg", "bg");

    output["chatMessageIncomingBg"] = get("chatMessageIncomingBg", "chatBg");
    output["chatMessageIncomingText"] = get("chatMessageIncomingText", "text");
    output["chatMessageIncomingLink"] = get("chatMessageIncomingLink", "link");
    output["chatMessageIncomingBorder"] = get("chatMessageIncomingBorder", "border");

    output["chatMessageOutgoingBg"] = get("chatMessageOutgoingBg", "chatMessageIncomingBg");
    output["chatMessageOutgoingText"] = get("chatMessageOutgoingText", "text");
    output["chatMessageOutgoingLink"] = get("chatMessageOutgoingLink", "link");
    output["chatMessageOutgoingBorder"] = get("chatMessageOutgoingBorder", "chatMessageOutgoingBg");

    return output;
  }

  // Translates a Pleroma theme into a Material one.
  ThemeData toMaterialTheme() {
    var brightness = Utils.isLightBackground(colors["bg"])
      ? Brightness.light
      : Brightness.dark;

    return ThemeData.from(
      colorScheme: ColorScheme(
        background: colors["bg"],
        primary: colors["topBar"],
        primaryVariant: colors["topBar"],
        error: colors["cRed"],
        surface: colors["fg"],
        secondary: colors["accent"],
        secondaryVariant: colors["accent"],
        brightness: brightness,
        onBackground:  colors["text"],
        onPrimary: colors["topBarText"],
        onSurface: colors["fgText"],
        onSecondary: colors["fgText"],
        onError: colors["alertErrorText"],
      ),
    ).copyWith(

      // buttons
      buttonTheme: ButtonThemeData(
        padding: EdgeInsets.symmetric(horizontal: 14),
        disabledColor: colors["btnDisabled"],
        buttonColor: colors["btn"],
        shape: RoundedRectangleBorder(
          borderRadius: getRadius("btn") ?? 8,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors["btn"],
        foregroundColor: colors["btnText"],
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: colors["selectedMenuIcon"],
        unselectedItemColor: colors["link"],
      ),
      appBarTheme: AppBarTheme(
        color: colors["topBar"],
        iconTheme: IconThemeData(
            color: colors["topBarLink"],
        ),
        actionsIconTheme: IconThemeData(
            color: colors["topBarLink"],
        ),
      ),

      // primary colors
      // primaryColor: colors["link"],
      // primaryIconTheme: IconThemeData(
      //     color: link
      // ),
      // primaryTextTheme: getSingleColorTextTheme(getColor(["topBarLink", "link"], defaultAccent)),

      // accent color
      // accentColor: getColor(["topBarLink", "link"], defaultAccent),

      // iconTheme: IconThemeData(
      //     color: getColor(["icon"], defaultIcon)
      // ),
      // textTheme: TextTheme(
      //   bodyText1: TextStyle(color: getColor(["text"], defaultFg)),
      // ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: colors["input"],
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: getRadius("input") ?? 24,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 7,
          vertical: 8
        ),
        isDense: true
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colors["popover"],
        textStyle: TextStyle(
          color: colors["popoverText"],
        ),
      ),
    );
  }

  BorderRadius getRadius(String key) {
    if (radii.containsKey(key))
      return BorderRadius.circular(radii[key]);

    return null;
  }

  //Color getColor(List<String> keys, {Color fallback, Map<String, String> source}) {
  //  for (var key in keys) {
  //    try {
  //      if (colors.containsKey(key))
  //        return toColor(colors[key]);
  //    } catch (_) {
  //    }
  //  }
  //
  //  if (fallback == null)
  //     throw "No color found, tried searching for $keys";
  //
  //  return fallback;
  //}

  Color toColor(String hex) {
    if (hex.isNullOrEmpty)
      throw "Hex can't be null or empty";

    return hex.toColor();
  }

  TextTheme getSingleColorTextTheme(Color color) {
    var textTheme = Typography.material2018().black;
    textTheme.apply(
      decorationColor: color,
      bodyColor: color,
      displayColor: color,
    );
    return textTheme;
  }

  @override
  AppTheme toTheme() {
    return AppTheme(
      materialTheme: toMaterialTheme(),
      linkColor: getColor("link")
    );
  }
}