// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_prober.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: avoid_private_typedef_functions, non_constant_identifier_names, subtype_of_sealed_class, invalid_use_of_internal_member, unused_element, constant_identifier_names, unnecessary_raw_strings, library_private_types_in_public_api

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

String $probeInstanceHash() => r'7360cc60a8cfc53b6ff6ca6ca1263f35eb1863f8';

/// See also [probeInstance].
class ProbeInstanceProvider
    extends AutoDisposeFutureProvider<InstanceProbeResult> {
  ProbeInstanceProvider(
    this.host,
  ) : super(
          (ref) => probeInstance(
            ref,
            host,
          ),
          from: probeInstanceProvider,
          name: r'probeInstanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $probeInstanceHash,
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

typedef ProbeInstanceRef = AutoDisposeFutureProviderRef<InstanceProbeResult>;

/// See also [probeInstance].
final probeInstanceProvider = ProbeInstanceFamily();

class ProbeInstanceFamily extends Family<AsyncValue<InstanceProbeResult>> {
  ProbeInstanceFamily();

  ProbeInstanceProvider call(
    String host,
  ) {
    return ProbeInstanceProvider(
      host,
    );
  }

  @override
  AutoDisposeFutureProvider<InstanceProbeResult> getProviderOverride(
    covariant ProbeInstanceProvider provider,
  ) {
    return call(
      provider.host,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'probeInstanceProvider';
}
