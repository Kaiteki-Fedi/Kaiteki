import 'package:flutter/src/widgets/basic.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/ui/user/user_card.dart';
import 'package:widgetbook/widgetbook.dart';

List<WidgetbookComponent> buildUserComponents() {
  return [
    WidgetbookComponent(
      name: "UserCard",
      useCases: [
        WidgetbookUseCase.center(
          name: "Example user",
          child: SizedBox(
            width: 300,
            child: UserCard(user: User.example()),
          ),
        ),
      ],
    )
  ];
}
