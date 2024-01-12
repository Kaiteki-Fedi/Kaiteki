library kaiteki_ui;

import 'package:flutter/material.dart';

export 'src/async/async_block_widget.dart';
export 'src/material/border_radii.dart';
export 'src/material/dialog_button_bar.dart';
export 'src/material/focus_ring.dart';
export 'src/material/main_switch_list_tile.dart';
export 'src/material/shapes.dart';
export 'src/material/side_sheet_manager.dart';
export 'src/material/window_size_class.dart';
export 'src/utils/extensions.dart';
export 'src/utils/margined_rounded_rectangle_border.dart';
export 'src/utils/margined_stadium_border.dart';
export 'src/utils/text_inherited_icon_theme.dart';

TextStyle getSubheaderTextStyle(ThemeData theme) {
  final labelLarge = theme.textTheme.labelLarge;
  final primary = theme.colorScheme.primary;

  if (labelLarge == null) return TextStyle(color: primary);

  return labelLarge.copyWith(color: primary);
}

typedef ColorSchemeBundle = ({ColorScheme dark, ColorScheme light});
