import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:notified_preferences/notified_preferences.dart";

/// Creates a new Preference of type [T].
/// A key and an initial value have to be provided.
///
/// The following types have default values for [read] and [write] :
/// `String, int, double, bool, List<String>` and their nullable versions.
///
/// - If you do not provide [read] and [write] methods and your type is not supported, an error will be thrown.
///
/// - If your type is nullable and initially null, provide null for [initialValue].
///
/// - It is possible to not use the [SharedPreferences] object passed to [read] and [write] and instead write your own logic for storing a Preference.
ChangeNotifierProvider<PreferenceNotifier<T>> createSettingProvider<T>({
  required String key,
  required T initialValue,
  ReadPreference<T>? read,
  WritePreference<T>? write,
  required Provider<SharedPreferences> provider,
}) {
  return ChangeNotifierProvider<PreferenceNotifier<T>>(
    (ref) {
      final preferences = ref.watch(provider);
      return PreferenceNotifier<T>(
        preferences: preferences,
        key: key,
        initialValue: initialValue,
        read: read,
        write: write,
      );
    },
    dependencies: [provider],
  );
}

/// Creates a Preference that is encoded and decoded from json.
///
/// Types using this must provide a toJson method.
/// [fromJson] will be used to instantiate the object.
ChangeNotifierProvider<PreferenceNotifier<T>> createJsonSettingProvider<T>({
  required String key,
  required T initialValue,
  required DecodeJsonPreference<T> fromJson,
  required Provider<SharedPreferences> provider,
}) {
  return ChangeNotifierProvider<PreferenceNotifier<T>>(
    (ref) {
      final preferences = ref.watch(provider);
      return PreferenceNotifier.json<T>(
        preferences: preferences,
        key: key,
        initialValue: initialValue,
        fromJson: fromJson,
      );
    },
    dependencies: [provider],
  );
}

/// Creates an Enum Setting.
/// The enum value is stored and read as by its `name` property.
ChangeNotifierProvider<PreferenceNotifier<T>>
    createEnumSettingProvider<T extends Enum>({
  required String key,
  required T initialValue,
  required List<T> values,
  required Provider<SharedPreferences> provider,
}) {
  return ChangeNotifierProvider<PreferenceNotifier<T>>(
    (ref) {
      final preferences = ref.watch(provider);
      return PreferenceNotifier.enums<T>(
        preferences: preferences,
        key: key,
        initialValue: initialValue,
        values: values,
      );
    },
    dependencies: [provider],
  );
}
