// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_prober.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$probeInstanceHash() => r'f01827bc259c3ab21ffe8f97f539d1f4ca97c705';

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

/// See also [probeInstance].
@ProviderFor(probeInstance)
const probeInstanceProvider = ProbeInstanceFamily();

/// See also [probeInstance].
class ProbeInstanceFamily extends Family<AsyncValue<core.InstanceProbeResult>> {
  /// See also [probeInstance].
  const ProbeInstanceFamily();

  /// See also [probeInstance].
  ProbeInstanceProvider call(
    String host,
  ) {
    return ProbeInstanceProvider(
      host,
    );
  }

  @override
  ProbeInstanceProvider getProviderOverride(
    covariant ProbeInstanceProvider provider,
  ) {
    return call(
      provider.host,
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
  String? get name => r'probeInstanceProvider';
}

/// See also [probeInstance].
class ProbeInstanceProvider
    extends AutoDisposeFutureProvider<core.InstanceProbeResult> {
  /// See also [probeInstance].
  ProbeInstanceProvider(
    String host,
  ) : this._internal(
          (ref) => probeInstance(
            ref as ProbeInstanceRef,
            host,
          ),
          from: probeInstanceProvider,
          name: r'probeInstanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$probeInstanceHash,
          dependencies: ProbeInstanceFamily._dependencies,
          allTransitiveDependencies:
              ProbeInstanceFamily._allTransitiveDependencies,
          host: host,
        );

  ProbeInstanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.host,
  }) : super.internal();

  final String host;

  @override
  Override overrideWith(
    FutureOr<core.InstanceProbeResult> Function(ProbeInstanceRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProbeInstanceProvider._internal(
        (ref) => create(ref as ProbeInstanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        host: host,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<core.InstanceProbeResult> createElement() {
    return _ProbeInstanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProbeInstanceProvider && other.host == host;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, host.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProbeInstanceRef
    on AutoDisposeFutureProviderRef<core.InstanceProbeResult> {
  /// The parameter `host` of this provider.
  String get host;
}

class _ProbeInstanceProviderElement
    extends AutoDisposeFutureProviderElement<core.InstanceProbeResult>
    with ProbeInstanceRef {
  _ProbeInstanceProviderElement(super.provider);

  @override
  String get host => (origin as ProbeInstanceProvider).host;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
