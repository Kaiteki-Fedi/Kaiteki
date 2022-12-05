import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/ui/auth/login/dialogs/api_web_compatibility_dialog.dart';
import 'package:kaiteki/ui/shared/dialogs/keyboard_shortcuts_dialog.dart';
import 'package:kaiteki/ui/shared/posts/compose/discard_post_dialog.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

import '../constants.dart';

final discardPost = Story(
  name: "Dialogs/Discard post",
  builder: (_) => const DiscardPostDialog(),
);

final apiWebCompatibility = Story(
  name: "Dialogs/API web compatibility",
  builder: (context) => ApiWebCompatibilityDialog(
    type: context.knobs.options(
      label: "API Type",
      initial: ApiType.mastodon,
      options: apiTypeOptions,
    ),
  ),
);

final keyboardShortcuts = Story(
  name: "Dialogs/Keyboard shortcuts",
  builder: (_) => const KeyboardShortcutsDialog(),
);
