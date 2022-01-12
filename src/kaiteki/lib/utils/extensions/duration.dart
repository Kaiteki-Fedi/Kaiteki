import 'package:flutter/widgets.dart';
import 'package:kaiteki/di.dart';

extension DurationExtension on Duration {
  String toStringHuman({BuildContext? context}) {
    final l10n = context?.getL10n();

    if (inDays != 0) {
      return l10n?.timeDifferenceDays(inDays) ?? "${inDays}d";
    } else if (inHours != 0) {
      return l10n?.timeDifferenceHours(inHours) ?? "${inHours}h";
    } else if (inMinutes != 0) {
      return l10n?.timeDifferenceMinutes(inMinutes) ?? "${inMinutes}m";
    } else {
      return l10n?.timeDifferenceSeconds(inSeconds) ?? "${inSeconds}s";
    }
  }
}
