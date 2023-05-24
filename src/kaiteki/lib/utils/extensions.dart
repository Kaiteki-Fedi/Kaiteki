import "package:breakpoint/breakpoint.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:html/dom.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/adapter.dart";
import "package:kaiteki/fediverse/model/post/post.dart";
import "package:kaiteki/fediverse/model/user/reference.dart";
import "package:kaiteki/fediverse/model/user/user.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/utils/utils.dart";

export "package:kaiteki/text/rendering_extensions.dart";
export "package:kaiteki/utils/extensions/build_context.dart";
export "package:kaiteki/utils/extensions/duration.dart";
export "package:kaiteki/utils/extensions/enum.dart";
export "package:kaiteki/utils/extensions/iterable.dart";
export "package:kaiteki/utils/extensions/string.dart";

extension ObjectExtensions<T> on T? {
  S? nullTransform<S>(S Function(T object) function) {
    final value = this;
    if (value == null) return null;
    return function.call(value);
  }

  S? safeCast<S>() {
    final value = this;
    if (value is S) return value;
    return null;
  }

  T inlineBang(String description) {
    final value = this;
    if (value == null) throw Exception(description);
    return value;
  }
}

extension BrightnessExtensions on Brightness {
  Brightness get inverted {
    return switch (this) {
      Brightness.dark => Brightness.light,
      Brightness.light => Brightness.dark
    };
  }

  SystemUiOverlayStyle get systemUiOverlayStyle {
    return switch (this) {
      Brightness.dark => SystemUiOverlayStyle.dark,
      Brightness.light => SystemUiOverlayStyle.light
    };
  }

  Color getColor({
    Color dark = const Color(0xFF000000),
    Color light = const Color(0xFFFFFFFF),
  }) {
    return switch (this) { Brightness.dark => dark, Brightness.light => light };
  }
}

extension TextDirectionExtensions on TextDirection {
  TextDirection get inverted {
    return switch (this) {
      TextDirection.ltr => TextDirection.rtl,
      TextDirection.rtl => TextDirection.ltr
    };
  }
}

enum AsyncSnapshotState { errored, loading, done }

extension PostExtensions on Post {
  Post get root {
    final repeatOf = this.repeatOf;
    return repeatOf == null ? this : repeatOf.root;
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
    final id = this.id;
    if (id != null) {
      return adapter.getUserById(id);
    }

    final username = this.username;
    if (username != null) {
      return adapter.lookupUser(username, host);
    }

    return null;
  }
}

extension WidgetRefExtensions on WidgetRef {
  String getCurrentAccountHandle() {
    final accountKey = read(accountProvider)!.key;
    return "@${accountKey.username}@${accountKey.host}";
  }

  Map<String, String> get accountRouterParams {
    final accountKey = read(accountProvider)!.key;
    return accountKey.routerParams;
  }
}

extension ProviderContainerExtensions on ProviderContainer {
  Map<String, String> get accountRouterParams {
    final accountKey = read(accountProvider)!.key;
    return accountKey.routerParams;
  }
}

extension AccountKeyExtensions on AccountKey {
  Map<String, String> get routerParams {
    return {"accountUsername": username, "accountHost": host};
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
  (String, String) get fediverseHandle {
    var username = pathSegments.last;

    // FIXME(Craftplacer): This is just a lazy fix for empty usernames
    if (username.isEmpty) return (host, username);

    if (username[0] == "@") {
      username = username.substring(1);
    }
    return (host, username);
  }
}

extension ListExtensions<T> on List<T> {
  List<T> joinWithValue(T separator) {
    if (length <= 1) return this;

    return List<T>.generate(
      length * 2 - 1,
      (i) => i.isEven ? this[i ~/ 2] : separator,
    );
  }
}

extension NullableObjectExtensions on Object? {}

extension FunctionExtensions<T> on T Function(JsonMap) {
  T Function(Object?) get generic {
    return (obj) => this(obj! as JsonMap);
  }

  List<T>? Function(Object?) get genericList {
    return (obj) {
      if (obj == null) return null;
      final list = obj as List<dynamic>;
      final castedList = list.cast<JsonMap>();
      return castedList.map(this).toList();
    };
  }
}

extension NullableTextStyleExtensions on TextStyle? {
  /// Provides an empty [TextStyle] if null. For use with [TextStyle.copyWith].
  TextStyle get fallback => this ?? const TextStyle();
}
