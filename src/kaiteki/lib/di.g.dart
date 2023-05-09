// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$translatorHash() => r'9df641e03c09009524470d24d553f89d7d580a34';

/// See also [translator].
@ProviderFor(translator)
final translatorProvider = AutoDisposeProvider<Translator?>.internal(
  translator,
  name: r'translatorProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$translatorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TranslatorRef = AutoDisposeProviderRef<Translator?>;
String _$languageIdentificatorHash() =>
    r'50116f7b5d56f12c52c6dc1c826703d6054d2a8f';

/// See also [languageIdentificator].
@ProviderFor(languageIdentificator)
final languageIdentificatorProvider =
    AutoDisposeProvider<LanguageIdentificator?>.internal(
  languageIdentificator,
  name: r'languageIdentificatorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$languageIdentificatorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LanguageIdentificatorRef
    = AutoDisposeProviderRef<LanguageIdentificator?>;
String _$languageListHash() => r'6379885123a836693b8b287564329b03589a7bfc';

/// See also [languageList].
@ProviderFor(languageList)
final languageListProvider =
    AutoDisposeFutureProvider<UnmodifiableListView<Language>>.internal(
  languageList,
  name: r'languageListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$languageListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LanguageListRef
    = AutoDisposeFutureProviderRef<UnmodifiableListView<Language>>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
