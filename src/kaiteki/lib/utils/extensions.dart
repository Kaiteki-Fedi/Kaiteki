import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/dom.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/fediverse/model/user_reference.dart';
import 'package:kaiteki/utils/text/text_renderer.dart';

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
    switch (this) {
      case Brightness.dark:
        return Brightness.light;
      case Brightness.light:
        return Brightness.dark;
    }
  }

  SystemUiOverlayStyle get systemUiOverlayStyle {
    switch (this) {
      case Brightness.dark:
        return SystemUiOverlayStyle.dark;
      case Brightness.light:
        return SystemUiOverlayStyle.light;
    }
  }

  Color getColor({
    Color dark = const Color(0xFF000000),
    Color light = const Color(0xFFFFFFFF),
  }) {
    switch (this) {
      case Brightness.dark:
        return dark;
      case Brightness.light:
        return light;
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
    return renderText(context, displayName);
  }

  InlineSpan renderDescription(BuildContext context) {
    return renderText(context, description!);
  }

  InlineSpan renderText(BuildContext context, String text) {
    return const TextRenderer().render(
      context,
      text,
      textContext: TextContext(
        users: [],
        emojis: emojis?.toList(growable: false),
      ),
    );
  }

  String get handle {
    if (host == null) {
      return '@$username';
    } else {
      return '@$username@$host';
    }
  }
}

extension PostExtensions on Post {
  InlineSpan renderContent(
    BuildContext context,
    WidgetRef ref, {
    bool hideReplyee = false,
  }) {
    return const TextRenderer().render(
      context,
      content!,
      textContext: TextContext(
        emojis: emojis?.toList(growable: false),
        users: mentionedUsers,
        excludedUsers: [
          if (hideReplyee && replyToUser != null)
            UserReference.handle(
              replyToUser!.username,
              replyToUser!.host,
            )
        ],
      ),
    );
  }

  Post getRoot() => _getRoot(this);

  Post _getRoot(Post post) {
    final repeatChild = post.repeatOf;
    return repeatChild == null ? post : _getRoot(repeatChild);
  }
}

extension VectorExtensions<T> on Iterable<Iterable<T>> {
  List<T> concat() {
    final list = <T>[];
    for (final childList in this) {
      list.addAll(childList);
    }
    return list;
  }
}

extension HtmlNodeExtensions on Node {
  bool hasClass(String className) {
    return attributes["class"]?.split(" ").contains(className) == true;
  }
}

extension UserReferenceExtensions on UserReference {
  Future<User?> resolve(FediverseAdapter adapter) async {
    if (id != null) {
      return adapter.getUserById(id!);
    }

    // if (reference.username != null) {
    //   return await manager.adapter.getUser(reference.username!, reference.host);
    // }

    return null;
  }
}

extension WidgetRefExtensions on WidgetRef {
  String getCurrentAccountHandle() {
    final account = read(accountProvider).currentAccount.accountSecret;
    return "@${account.username}@${account.instance}";
  }
}
