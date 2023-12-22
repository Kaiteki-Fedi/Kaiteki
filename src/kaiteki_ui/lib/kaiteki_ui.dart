library kaiteki_ui;

import 'package:flutter/material.dart';

export 'src/async/async_block_widget.dart';
export 'src/material/border_radii.dart';
export 'src/material/main_switch_list_tile.dart';
export 'src/material/shapes.dart';
export 'src/material/side_sheet_manager.dart';
export 'src/utils/extensions.dart';
export 'src/utils/margined_rounded_rectangle_border.dart';
export 'src/utils/margined_stadium_border.dart';
export 'src/utils/text_inherited_icon_theme.dart';

double getLocalFontSize(BuildContext context) {
  return DefaultTextStyle.of(context).style.fontSize!;
}

Color getLocalTextColor(BuildContext context) {
  return DefaultTextStyle.of(context).style.color!;
}

TextStyle getSubheaderTextStyle(ThemeData theme) {
  final labelLarge = theme.textTheme.labelLarge;
  final primary = theme.colorScheme.primary;

  if (labelLarge == null) return TextStyle(color: primary);

  return labelLarge.copyWith(color: primary);
}

typedef ColorSchemeBundle = ({ColorScheme dark, ColorScheme light});
