import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/ui/auth/login/dialogs/api_type_dialog.dart';
import 'package:kaiteki/ui/auth/login/dialogs/api_web_compatibility_dialog.dart';
import 'package:kaiteki/ui/shared/dialogs/account_removal_dialog.dart';
import 'package:widgetbook/widgetbook.dart';

import '../widgetboot_extensions.dart';

List<WidgetbookComponent> buildDialogComponents() {
  return [
    WidgetbookComponent(
      name: "ApiWebCompatibilityDialog",
      useCases: [
        WidgetbookUseCase(
          name: "Default",
          builder: (context) {
            return ColoredBox(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Center(
                child: ApiWebCompatibilityDialog(
                  type: context.knobs.enumOptions(
                    label: "API type",
                    values: ApiType.values,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    ),
    WidgetbookComponent(
      name: "ApiTypeDialog",
      useCases: [
        WidgetbookUseCase(
          name: "Default",
          builder: (context) {
            return ColoredBox(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: const Center(child: ApiTypeDialog()),
            );
          },
        ),
      ],
    ),
    WidgetbookComponent(
      name: "AccountRemovalDialog",
      useCases: [
        WidgetbookUseCase(
          name: "Default",
          builder: (context) {
            return ColoredBox(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: const Center(child: AccountRemovalDialog()),
            );
          },
        ),
      ],
    ),
  ];
}
