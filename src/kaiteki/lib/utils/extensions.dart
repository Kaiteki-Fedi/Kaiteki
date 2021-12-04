import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/utils/text/text_renderer.dart';
import 'package:kaiteki/utils/text/text_renderer_theme.dart';

export 'package:kaiteki/utils/extensions/build_context.dart';
export 'package:kaiteki/utils/extensions/duration.dart';
export 'package:kaiteki/utils/extensions/iterable.dart';
export 'package:kaiteki/utils/extensions/string.dart';

extension ObjectExtensions<T> on Object? {
  T2? nullTransform<T2>(T2 Function(T object) function) {
    if (this == null) return null;

    return function.call(this! as T);
  }
}

extension BrightnessExtensions on Brightness {
  Brightness get inverted {
    if (this == Brightness.light) {
      return Brightness.dark;
    } else {
      return Brightness.dark;
    }
  }
}

extension AsyncSnapshotExtensions on AsyncSnapshot {
  AsyncSnapshotState get state {
    if (hasError) {
      return AsyncSnapshotState.errored;
    } else if (!hasData) {
      return AsyncSnapshotState.loading;
    } else {
      return AsyncSnapshotState.done;
    }
  }
}

enum AsyncSnapshotState { errored, loading, done }

extension UserExtensions on User {
  InlineSpan renderDisplayName(BuildContext context) {
    final theme = TextRendererTheme.fromContext(context);
    final renderer = TextRenderer(emojis: emojis, theme: theme);
    return renderer.renderFromHtml(context, displayName);
  }
}

extension PostExtensions on Post {
  InlineSpan renderContent(BuildContext context) {
    final theme = TextRendererTheme.fromContext(context);
    final renderer = TextRenderer(emojis: emojis, theme: theme);
    return renderer.renderFromHtml(context, content!);
  }
}
