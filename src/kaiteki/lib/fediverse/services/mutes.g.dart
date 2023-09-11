// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mutes.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mutesServiceHash() => r'da65ccfba745c9c0ba42f24404b9dcc1af207e99';

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

abstract class _$MutesService
    extends BuildlessAsyncNotifier<PaginationState<User<dynamic>>> {
  late final AccountKey key;

  FutureOr<PaginationState<User<dynamic>>> build(
    AccountKey key,
  );
}

/// See also [MutesService].
@ProviderFor(MutesService)
const mutesServiceProvider = MutesServiceFamily();

/// See also [MutesService].
class MutesServiceFamily
    extends Family<AsyncValue<PaginationState<User<dynamic>>>> {
  /// See also [MutesService].
  const MutesServiceFamily();

  /// See also [MutesService].
  MutesServiceProvider call(
    AccountKey key,
  ) {
    return MutesServiceProvider(
      key,
    );
  }

  @override
  MutesServiceProvider getProviderOverride(
    covariant MutesServiceProvider provider,
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
  String? get name => r'mutesServiceProvider';
}

/// See also [MutesService].
class MutesServiceProvider extends AsyncNotifierProviderImpl<MutesService,
    PaginationState<User<dynamic>>> {
  /// See also [MutesService].
  MutesServiceProvider(
    AccountKey key,
  ) : this._internal(
          () => MutesService()..key = key,
          from: mutesServiceProvider,
          name: r'mutesServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mutesServiceHash,
          dependencies: MutesServiceFamily._dependencies,
          allTransitiveDependencies:
              MutesServiceFamily._allTransitiveDependencies,
          key: key,
        );

  MutesServiceProvider._internal(
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
  FutureOr<PaginationState<User<dynamic>>> runNotifierBuild(
    covariant MutesService notifier,
  ) {
    return notifier.build(
      key,
    );
  }

  @override
  Override overrideWith(MutesService Function() create) {
    return ProviderOverride(
      origin: this,
      override: MutesServiceProvider._internal(
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
  AsyncNotifierProviderElement<MutesService, PaginationState<User<dynamic>>>
      createElement() {
    return _MutesServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MutesServiceProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MutesServiceRef
    on AsyncNotifierProviderRef<PaginationState<User<dynamic>>> {
  /// The parameter `key` of this provider.
  AccountKey get key;
}

class _MutesServiceProviderElement extends AsyncNotifierProviderElement<
    MutesService, PaginationState<User<dynamic>>> with MutesServiceRef {
  _MutesServiceProviderElement(super.provider);

  @override
  AccountKey get key => (origin as MutesServiceProvider).key;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
