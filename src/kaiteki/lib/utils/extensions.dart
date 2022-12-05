import 'package:breakpoint/breakpoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/dom.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/fediverse/model/user_reference.dart';
import 'package:kaiteki/utils/helpers.dart';
import 'package:kaiteki/utils/text/text_renderer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

export 'package:kaiteki/utils/extensions/build_context.dart';
export 'package:kaiteki/utils/extensions/duration.dart';
export 'package:kaiteki/utils/extensions/enum.dart';
export 'package:kaiteki/utils/extensions/iterable.dart';
export 'package:kaiteki/utils/extensions/m3.dart';
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

extension TextDirectionExtensions on TextDirection {
  TextDirection get inverted {
    switch (this) {
      case TextDirection.ltr:
        return TextDirection.rtl;
      case TextDirection.rtl:
        return TextDirection.ltr;
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
  InlineSpan renderDisplayName(BuildContext context, WidgetRef ref) {
    return renderText(context, ref, displayName!);
  }

  InlineSpan renderDescription(BuildContext context, WidgetRef ref) {
    return renderText(context, ref, description!);
  }

  InlineSpan renderText(BuildContext context, WidgetRef ref, String text) {
    return const TextRenderer().render(
      context,
      text,
      textContext: TextContext(
        users: [],
        emojis: emojis?.toList(growable: false),
      ),
      onUserClick: (reference) => resolveAndOpenUser(reference, context, ref),
    );
  }

  String get handle => '@$username@$host';
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
      onUserClick: (reference) => resolveAndOpenUser(reference, context, ref),
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
  Future<User?> resolve(BackendAdapter adapter) async {
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
    final account = read(accountProvider).current;
    return "@${account.key.username}@${account.key.host}";
  }

  Map<String, String> get accountRouterParams {
    final accountKey = read(accountProvider).current.key;
    return {
      "accountUsername": accountKey.username,
      "accountHost": accountKey.host,
    };
  }
}

extension BreakpointExtensions on Breakpoint {
  double? get margin {
    if (window == WindowSize.xsmall) return 16;
    if (window == WindowSize.small && columns == 8) return 32;
    if (window == WindowSize.small && columns == 12) return null;
    if (window == WindowSize.medium) return 200;
    return null;
  }

  double? get body {
    if (window == WindowSize.xsmall) return null;
    if (window == WindowSize.small && columns == 8) return null;
    if (window == WindowSize.small && columns == 12) return 840;
    if (window == WindowSize.medium) return null;
    return 1040;
  }
}

extension QueryExtension on Map<String, String> {
  String toQueryString() {
    if (isEmpty) return "";

    final pairs = <String>[];
    for (final kv in entries) {
      final key = Uri.encodeQueryComponent(kv.key);
      final value = Uri.encodeQueryComponent(kv.value);
      pairs.add("$key=$value");
    }
    return "?${pairs.join("&")}";
  }
}

extension UriExtensions on Uri {
  Tuple2<String, String> get fediverseHandle {
    var username = pathSegments.last;
    if (username[0] == '@') {
      username = username.substring(1);
    }
    return Tuple2(host, username);
  }
}

extension ListExtensions<T> on List<T> {
  List<T> joinNonString(T separator) {
    if (length <= 1) return this;

    return List<T>.generate(
      length * 2 - 1,
      (i) => i % 2 == 0 ? this[i ~/ 2] : separator,
    );
  }
}

extension SharedPreferencesExtensions on SharedPreferences {
  Future<bool> setTristateBool(key, value) async {
    if (value != null) return setBool(key, value);
    if (containsKey(key)) return remove(key);
    return true;
  }
}

extension NullableObjectExtensions on Object? {}

extension FunctionExtensions<T> on T Function(Map<String, dynamic>) {
  T Function(Object?) get generic {
    return (obj) => this(obj as Map<String, dynamic>);
  }

  List<T>? Function(Object?) get genericList {
    return (obj) {
      if (obj == null) return null;
      final list = obj as List<dynamic>;
      final castedList = list.cast<Map<String, dynamic>>();
      return castedList.map(this).toList();
    };
  }
}
