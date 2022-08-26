import 'package:flutter/material.dart';
import 'package:kaiteki/ui/shared/async/async_button.dart';
import 'package:widgetbook/widgetbook.dart';

List<WidgetbookComponent> buildComponents() {
  return [
    WidgetbookComponent(
      name: "AsyncButton",
      useCases: [
        WidgetbookUseCase(
          name: "Default",
          builder: (context) {
            return ColoredBox(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Center(
                child: AsyncButton(
                  onPressed: () => Future.delayed(const Duration(seconds: 3)),
                  child: const Text("Async Button!"),
                ),
              ),
            );
          },
        ),
      ],
    ),
  ];
}
