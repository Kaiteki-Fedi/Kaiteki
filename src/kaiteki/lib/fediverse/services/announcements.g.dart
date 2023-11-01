// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcements.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$announcementsServiceHash() =>
    r'5d956ee8eec1b43b33370549e2a538be2e01b32e';

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

abstract class _$AnnouncementsService
    extends BuildlessAsyncNotifier<List<Announcement>> {
  late final AccountKey key;

  Future<List<Announcement>> build(
    AccountKey key,
  );
}

/// See also [AnnouncementsService].
@ProviderFor(AnnouncementsService)
const announcementsServiceProvider = AnnouncementsServiceFamily();

/// See also [AnnouncementsService].
class AnnouncementsServiceFamily
    extends Family<AsyncValue<List<Announcement>>> {
  /// See also [AnnouncementsService].
  const AnnouncementsServiceFamily();

  /// See also [AnnouncementsService].
  AnnouncementsServiceProvider call(
    AccountKey key,
  ) {
    return AnnouncementsServiceProvider(
      key,
    );
  }

  @override
  AnnouncementsServiceProvider getProviderOverride(
    covariant AnnouncementsServiceProvider provider,
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
  String? get name => r'announcementsServiceProvider';
}

/// See also [AnnouncementsService].
class AnnouncementsServiceProvider extends AsyncNotifierProviderImpl<
    AnnouncementsService, List<Announcement>> {
  /// See also [AnnouncementsService].
  AnnouncementsServiceProvider(
    AccountKey key,
  ) : this._internal(
          () => AnnouncementsService()..key = key,
          from: announcementsServiceProvider,
          name: r'announcementsServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$announcementsServiceHash,
          dependencies: AnnouncementsServiceFamily._dependencies,
          allTransitiveDependencies:
              AnnouncementsServiceFamily._allTransitiveDependencies,
          key: key,
        );

  AnnouncementsServiceProvider._internal(
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
  Future<List<Announcement>> runNotifierBuild(
    covariant AnnouncementsService notifier,
  ) {
    return notifier.build(
      key,
    );
  }

  @override
  Override overrideWith(AnnouncementsService Function() create) {
    return ProviderOverride(
      origin: this,
      override: AnnouncementsServiceProvider._internal(
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
  AsyncNotifierProviderElement<AnnouncementsService, List<Announcement>>
      createElement() {
    return _AnnouncementsServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AnnouncementsServiceProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AnnouncementsServiceRef on AsyncNotifierProviderRef<List<Announcement>> {
  /// The parameter `key` of this provider.
  AccountKey get key;
}

class _AnnouncementsServiceProviderElement extends AsyncNotifierProviderElement<
    AnnouncementsService, List<Announcement>> with AnnouncementsServiceRef {
  _AnnouncementsServiceProviderElement(super.provider);

  @override
  AccountKey get key => (origin as AnnouncementsServiceProvider).key;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
