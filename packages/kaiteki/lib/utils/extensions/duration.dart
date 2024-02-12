import "package:kaiteki_l10n/kaiteki_l10n.dart";

extension DurationExtension on Duration {
  String toStringHuman(KaitekiLocalizations l10n) {
    if (inDays != 0) {
      return l10n.timeDifferenceDays(inDays);
    } else if (inHours != 0) {
      return l10n.timeDifferenceHours(inHours);
    } else if (inMinutes != 0) {
      return l10n.timeDifferenceMinutes(inMinutes);
    } else if (inSeconds <= 5) {
      return l10n.timeDifferenceNow;
    } else {
      return l10n.timeDifferenceSeconds(inSeconds);
    }
  }

  String toLongString(KaitekiLocalizations l10n) {
    if (inDays != 0) {
      return l10n.timeDifferenceDaysLong(inDays);
    } else if (inHours != 0) {
      return l10n.timeDifferenceHoursLong(inHours);
    } else if (inMinutes != 0) {
      return l10n.timeDifferenceMinutesLong(inMinutes);
    } else if (inSeconds <= 5) {
      return l10n.timeDifferenceNow;
    } else {
      return l10n.timeDifferenceSecondsLong(inSeconds);
    }
  }
}
