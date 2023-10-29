// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmarks.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookmarksServiceHash() => r'92d583738e62712f6716f5df4f2f910fa6f6b895';

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

abstract class _$BookmarksService
    extends BuildlessAsyncNotifier<PaginationState<Post>> {
  late final AccountKey key;

  FutureOr<PaginationState<Post>> build(
    AccountKey key,
  );
}

/// See also [BookmarksService].
@ProviderFor(BookmarksService)
const bookmarksServiceProvider = BookmarksServiceFamily();

/// See also [BookmarksService].
class BookmarksServiceFamily extends Family<AsyncValue<PaginationState<Post>>> {
  /// See also [BookmarksService].
  const BookmarksServiceFamily();

  /// See also [BookmarksService].
  BookmarksServiceProvider call(
    AccountKey key,
  ) {
    return BookmarksServiceProvider(
      key,
    );
  }

  @override
  BookmarksServiceProvider getProviderOverride(
    covariant BookmarksServiceProvider provider,
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
  String? get name => r'bookmarksServiceProvider';
}

/// See also [BookmarksService].
class BookmarksServiceProvider
    extends AsyncNotifierProviderImpl<BookmarksService, PaginationState<Post>> {
  /// See also [BookmarksService].
  BookmarksServiceProvider(
    AccountKey key,
  ) : this._internal(
          () => BookmarksService()..key = key,
          from: bookmarksServiceProvider,
          name: r'bookmarksServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookmarksServiceHash,
          dependencies: BookmarksServiceFamily._dependencies,
          allTransitiveDependencies:
              BookmarksServiceFamily._allTransitiveDependencies,
          key: key,
        );

  BookmarksServiceProvider._internal(
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
  FutureOr<PaginationState<Post>> runNotifierBuild(
    covariant BookmarksService notifier,
  ) {
    return notifier.build(
      key,
    );
  }

  @override
  Override overrideWith(BookmarksService Function() create) {
    return ProviderOverride(
      origin: this,
      override: BookmarksServiceProvider._internal(
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
  AsyncNotifierProviderElement<BookmarksService, PaginationState<Post>>
      createElement() {
    return _BookmarksServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookmarksServiceProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BookmarksServiceRef on AsyncNotifierProviderRef<PaginationState<Post>> {
  /// The parameter `key` of this provider.
  AccountKey get key;
}

class _BookmarksServiceProviderElement extends AsyncNotifierProviderElement<
    BookmarksService, PaginationState<Post>> with BookmarksServiceRef {
  _BookmarksServiceProviderElement(super.provider);

  @override
  AccountKey get key => (origin as BookmarksServiceProvider).key;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
