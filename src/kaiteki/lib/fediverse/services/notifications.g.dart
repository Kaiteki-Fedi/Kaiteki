// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications.dart';

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

String $NotificationServiceHash() =>
    r'7c1059c06e5a9217672d2d31d3dcca09c884059a';

/// See also [NotificationService].
class NotificationServiceProvider
    extends AsyncNotifierProviderImpl<NotificationService, List<Notification>> {
  NotificationServiceProvider(
    this.key,
  ) : super(
          () => NotificationService()..key = key,
          from: notificationServiceProvider,
          name: r'notificationServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $NotificationServiceHash,
        );

  final AccountKey key;

  @override
  bool operator ==(Object other) {
    return other is NotificationServiceProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  FutureOr<List<Notification>> runNotifierBuild(
    covariant _$NotificationService notifier,
  ) {
    return notifier.build(
      key,
    );
  }
}

typedef NotificationServiceRef = AsyncNotifierProviderRef<List<Notification>>;

/// See also [NotificationService].
final notificationServiceProvider = NotificationServiceFamily();

class NotificationServiceFamily extends Family<AsyncValue<List<Notification>>> {
  NotificationServiceFamily();

  NotificationServiceProvider call(
    AccountKey key,
  ) {
    return NotificationServiceProvider(
      key,
    );
  }

  @override
  AsyncNotifierProviderImpl<NotificationService, List<Notification>>
      getProviderOverride(
    covariant NotificationServiceProvider provider,
  ) {
    return call(
      provider.key,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'notificationServiceProvider';
}

abstract class _$NotificationService
    extends BuildlessAsyncNotifier<List<Notification>> {
  late final AccountKey key;

  FutureOr<List<Notification>> build(
    AccountKey key,
  );
}
