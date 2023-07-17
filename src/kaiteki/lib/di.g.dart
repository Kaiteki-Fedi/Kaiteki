// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountHash() => r'0d16b5ab3d5fbdcaf4fc1f12f9e7a7be5ca08259';

/// See also [account].
@ProviderFor(account)
final accountProvider = Provider<Account?>.internal(
  account,
  name: r'accountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$accountHash,
  dependencies: <ProviderOrFamily>[accountManagerProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    accountManagerProvider,
    ...?accountManagerProvider.allTransitiveDependencies
  },
);

typedef AccountRef = ProviderRef<Account?>;
String _$adapterHash() => r'de277e9ae747c0f9b420465b09f3d2a8e80f1af7';

/// See also [adapter].
@ProviderFor(adapter)
final adapterProvider = Provider<BackendAdapter>.internal(
  adapter,
  name: r'adapterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$adapterHash,
  dependencies: <ProviderOrFamily>[accountProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    accountProvider,
    ...?accountProvider.allTransitiveDependencies
  },
);

typedef AdapterRef = ProviderRef<BackendAdapter>;
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
String _$textParserHash() => r'4103e3d4536a1119a0e2cea049bf933ca8f1861c';

/// See also [textParser].
@ProviderFor(textParser)
final textParserProvider = Provider<Set<TextParser>>.internal(
  textParser,
  name: r'textParserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$textParserHash,
  dependencies: <ProviderOrFamily>[adapterProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    adapterProvider,
    ...?adapterProvider.allTransitiveDependencies
  },
);

typedef TextParserRef = ProviderRef<Set<TextParser>>;
String _$languageListHash() => r'47585c70705158bdd9b5e9b6347637b2f1e3558d';

/// See also [languageList].
@ProviderFor(languageList)
final languageListProvider =
    FutureProvider<UnmodifiableListView<Language>>.internal(
  languageList,
  name: r'languageListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$languageListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LanguageListRef = FutureProviderRef<UnmodifiableListView<Language>>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
