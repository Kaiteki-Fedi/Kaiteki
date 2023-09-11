// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$emojiServiceHash() => r'fcc7d2b7ac11ec921d24313e3f7fc0330a7a5eab';

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

abstract class _$EmojiService
    extends BuildlessAsyncNotifier<List<EmojiCategory>> {
  late final AccountKey key;

  FutureOr<List<EmojiCategory>> build(
    AccountKey key,
  );
}

/// See also [EmojiService].
@ProviderFor(EmojiService)
const emojiServiceProvider = EmojiServiceFamily();

/// See also [EmojiService].
class EmojiServiceFamily extends Family<AsyncValue<List<EmojiCategory>>> {
  /// See also [EmojiService].
  const EmojiServiceFamily();

  /// See also [EmojiService].
  EmojiServiceProvider call(
    AccountKey key,
  ) {
    return EmojiServiceProvider(
      key,
    );
  }

  @override
  EmojiServiceProvider getProviderOverride(
    covariant EmojiServiceProvider provider,
  ) {
    return call(
      provider.key,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'emojiServiceProvider';
}

/// See also [EmojiService].
class EmojiServiceProvider
    extends AsyncNotifierProviderImpl<EmojiService, List<EmojiCategory>> {
  /// See also [EmojiService].
  EmojiServiceProvider(
    AccountKey key,
  ) : this._internal(
          () => EmojiService()..key = key,
          from: emojiServiceProvider,
          name: r'emojiServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$emojiServiceHash,
          dependencies: EmojiServiceFamily._dependencies,
          allTransitiveDependencies:
              EmojiServiceFamily._allTransitiveDependencies,
          key: key,
        );

  EmojiServiceProvider._internal(
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
  FutureOr<List<EmojiCategory>> runNotifierBuild(
    covariant EmojiService notifier,
  ) {
    return notifier.build(
      key,
    );
  }

  @override
  Override overrideWith(EmojiService Function() create) {
    return ProviderOverride(
      origin: this,
      override: EmojiServiceProvider._internal(
        () => create()..key = key,
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
  AsyncNotifierProviderElement<EmojiService, List<EmojiCategory>>
      createElement() {
    return _EmojiServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EmojiServiceProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin EmojiServiceRef on AsyncNotifierProviderRef<List<EmojiCategory>> {
  /// The parameter `key` of this provider.
  AccountKey get key;
}

class _EmojiServiceProviderElement
    extends AsyncNotifierProviderElement<EmojiService, List<EmojiCategory>>
    with EmojiServiceRef {
  _EmojiServiceProviderElement(super.provider);

  @override
  AccountKey get key => (origin as EmojiServiceProvider).key;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
