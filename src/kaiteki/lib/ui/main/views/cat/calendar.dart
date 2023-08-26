import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kaiteki/di.dart";

class CatCalendarWidget extends StatelessWidget {
  const CatCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    final yearProgress = date.month / 12;
    final monthProgress = date.day / 31;
    final dayProgress = date.hour / 23;
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Column(
                children: [
                  Text(
                    DateFormat("y M").format(date),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      DateFormat("d").format(date),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: const Color(0xffef95a0),
                          ),
                    ),
                  ),
                  Text(
                    DateFormat("EEEE").format(date),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(context.l10n.misskeyCalendarToday),
                      Text(
                        // ignore: l10n
                        "${(dayProgress * 100).toStringAsFixed(1)}%",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  LinearProgressIndicator(
                    color: const Color(0xFFf7796c),
                    value: dayProgress,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(context.l10n.misskeyCalendarMonth),
                      Text(
                        // ignore: l10n
                        "${(monthProgress * 100).toStringAsFixed(1)}%",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  LinearProgressIndicator(
                    color: const Color(0xFFa1de41),
                    value: monthProgress,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(context.l10n.misskeyCalendarYear),
                      Text(
                        // ignore: l10n
                        "${(yearProgress * 100).toStringAsFixed(1)}%",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  LinearProgressIndicator(
                    color: const Color(0xFF41ddde),
                    value: yearProgress,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
