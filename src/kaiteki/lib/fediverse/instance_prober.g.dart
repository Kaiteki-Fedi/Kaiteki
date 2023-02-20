// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_prober.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$probeInstanceHash() => r'2e4a8d040a0a93d901647dbdcb582c60948bce61';

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

typedef ProbeInstanceRef = AutoDisposeFutureProviderRef<InstanceProbeResult>;

/// See also [probeInstance].
@ProviderFor(probeInstance)
const probeInstanceProvider = ProbeInstanceFamily();

/// See also [probeInstance].
class ProbeInstanceFamily extends Family<AsyncValue<InstanceProbeResult>> {
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
    extends AutoDisposeFutureProvider<InstanceProbeResult> {
  /// See also [probeInstance].
  ProbeInstanceProvider(
    this.host,
  ) : super.internal(
          (ref) => probeInstance(
            ref,
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
        );

  final String host;

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
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
