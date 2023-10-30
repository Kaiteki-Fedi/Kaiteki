// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_resolver.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$resolveHash() => r'bbc6f53c8bdb3885e1a5b5f3cfb46659e1545ada';

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

/// See also [resolve].
@ProviderFor(resolve)
const resolveProvider = ResolveFamily();

/// See also [resolve].
class ResolveFamily extends Family<AsyncValue<ResolveUserResult?>> {
  /// See also [resolve].
  const ResolveFamily();

  /// See also [resolve].
  ResolveProvider call(
    AccountKey key,
    UserReference reference,
  ) {
    return ResolveProvider(
      key,
      reference,
    );
  }

  @override
  ResolveProvider getProviderOverride(
    covariant ResolveProvider provider,
  ) {
    return call(
      provider.key,
      provider.reference,
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
  String? get name => r'resolveProvider';
}

/// See also [resolve].
class ResolveProvider extends AutoDisposeFutureProvider<ResolveUserResult?> {
  /// See also [resolve].
  ResolveProvider(
    AccountKey key,
    UserReference reference,
  ) : this._internal(
          (ref) => resolve(
            ref as ResolveRef,
            key,
            reference,
          ),
          from: resolveProvider,
          name: r'resolveProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$resolveHash,
          dependencies: ResolveFamily._dependencies,
          allTransitiveDependencies: ResolveFamily._allTransitiveDependencies,
          key: key,
          reference: reference,
        );

  ResolveProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
    required this.reference,
  }) : super.internal();

  final AccountKey key;
  final UserReference reference;

  @override
  Override overrideWith(
    FutureOr<ResolveUserResult?> Function(ResolveRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ResolveProvider._internal(
        (ref) => create(ref as ResolveRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        key: key,
        reference: reference,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ResolveUserResult?> createElement() {
    return _ResolveProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ResolveProvider &&
        other.key == key &&
        other.reference == reference;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);
    hash = _SystemHash.combine(hash, reference.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ResolveRef on AutoDisposeFutureProviderRef<ResolveUserResult?> {
  /// The parameter `key` of this provider.
  AccountKey get key;

  /// The parameter `reference` of this provider.
  UserReference get reference;
}

class _ResolveProviderElement
    extends AutoDisposeFutureProviderElement<ResolveUserResult?>
    with ResolveRef {
  _ResolveProviderElement(super.provider);

  @override
  AccountKey get key => (origin as ResolveProvider).key;
  @override
  UserReference get reference => (origin as ResolveProvider).reference;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
