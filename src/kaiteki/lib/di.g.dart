// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountHash() => r'2266072226784fe67869921140f52e7d96e912de';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [account].
@ProviderFor(account)
const accountProvider = AccountFamily();

/// See also [account].
class AccountFamily extends Family<Account?> {
  /// See also [account].
  const AccountFamily();

  /// See also [account].
  AccountProvider call(
    AccountKey key,
  ) {
    return AccountProvider(
      key,
    );
  }

  @override
  AccountProvider getProviderOverride(
    covariant AccountProvider provider,
  ) {
    return call(
      provider.key,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    accountManagerProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    accountManagerProvider,
    ...?accountManagerProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'accountProvider';
}

/// See also [account].
class AccountProvider extends Provider<Account?> {
  /// See also [account].
  AccountProvider(
    AccountKey key,
  ) : this._internal(
          (ref) => account(
            ref as AccountRef,
            key,
          ),
          from: accountProvider,
          name: r'accountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountHash,
          dependencies: AccountFamily._dependencies,
          allTransitiveDependencies: AccountFamily._allTransitiveDependencies,
          key: key,
        );

  AccountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
  }) : super.internal();

  final AccountKey key;

  @override
  Override overrideWith(
    Account? Function(AccountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountProvider._internal(
        (ref) => create(ref as AccountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        key: key,
      ),
    );
  }

  @override
  ProviderElement<Account?> createElement() {
    return _AccountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountRef on ProviderRef<Account?> {
  /// The parameter `key` of this provider.
  AccountKey get key;
}

class _AccountProviderElement extends ProviderElement<Account?>
    with AccountRef {
  _AccountProviderElement(super.provider);

  @override
  AccountKey get key => (origin as AccountProvider).key;
}

String _$currentAccountHash() => r'acc6198fcf4092f25572c65b5d04029955101f13';

/// See also [currentAccount].
@ProviderFor(currentAccount)
final currentAccountProvider = Provider<Account?>.internal(
  currentAccount,
  name: r'currentAccountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentAccountHash,
  dependencies: <ProviderOrFamily>[accountManagerProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    accountManagerProvider,
    ...?accountManagerProvider.allTransitiveDependencies
  },
);

typedef CurrentAccountRef = ProviderRef<Account?>;

String _$adapterHash() => r'3a7624e3a59ce66597fe9a517264dad933d16a06';

/// See also [adapter].
@ProviderFor(adapter)
final adapterProvider = Provider<BackendAdapter>.internal(
  adapter,
  name: r'adapterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$adapterHash,
  dependencies: <ProviderOrFamily>[currentAccountProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    currentAccountProvider,
    ...?currentAccountProvider.allTransitiveDependencies
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

String _$textParserHash() => r'4c424236a063be641500d3ccc00827f6d0bc1f58';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
