// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lists.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$listsServiceHash() => r'5fb779bd1a3d4a1a07c5c254fbee3ed318eb21b0';

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

abstract class _$ListsService extends BuildlessAsyncNotifier<List<PostList>> {
  late final AccountKey key;

  FutureOr<List<PostList>> build(
    AccountKey key,
  );
}

/// See also [ListsService].
@ProviderFor(ListsService)
const listsServiceProvider = ListsServiceFamily();

/// See also [ListsService].
class ListsServiceFamily extends Family<AsyncValue<List<PostList>>> {
  /// See also [ListsService].
  const ListsServiceFamily();

  /// See also [ListsService].
  ListsServiceProvider call(
    AccountKey key,
  ) {
    return ListsServiceProvider(
      key,
    );
  }

  @override
  ListsServiceProvider getProviderOverride(
    covariant ListsServiceProvider provider,
  ) {
    return call(
      provider.key,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    adapterProvider,
    accountProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    adapterProvider,
    ...?adapterProvider.allTransitiveDependencies,
    accountProvider,
    ...?accountProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'listsServiceProvider';
}

/// See also [ListsService].
class ListsServiceProvider
    extends AsyncNotifierProviderImpl<ListsService, List<PostList>> {
  /// See also [ListsService].
  ListsServiceProvider(
    AccountKey key,
  ) : this._internal(
          () => ListsService()..key = key,
          from: listsServiceProvider,
          name: r'listsServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$listsServiceHash,
          dependencies: ListsServiceFamily._dependencies,
          allTransitiveDependencies:
              ListsServiceFamily._allTransitiveDependencies,
          key: key,
        );

  ListsServiceProvider._internal(
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
  FutureOr<List<PostList>> runNotifierBuild(
    covariant ListsService notifier,
  ) {
    return notifier.build(
      key,
    );
  }

  @override
  Override overrideWith(ListsService Function() create) {
    return ProviderOverride(
      origin: this,
      override: ListsServiceProvider._internal(
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
  AsyncNotifierProviderElement<ListsService, List<PostList>> createElement() {
    return _ListsServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ListsServiceProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ListsServiceRef on AsyncNotifierProviderRef<List<PostList>> {
  /// The parameter `key` of this provider.
  AccountKey get key;
}

class _ListsServiceProviderElement
    extends AsyncNotifierProviderElement<ListsService, List<PostList>>
    with ListsServiceRef {
  _ListsServiceProviderElement(super.provider);

  @override
  AccountKey get key => (origin as ListsServiceProvider).key;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
