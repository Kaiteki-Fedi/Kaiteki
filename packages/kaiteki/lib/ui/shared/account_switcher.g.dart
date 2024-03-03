// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_switcher.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$unreadNotificationsOnAltsHash() =>
    r'bcc66fb7ce1feda4adb4ed240183dc5a5669622b';

/// See also [_unreadNotificationsOnAlts].
@ProviderFor(_unreadNotificationsOnAlts)
final _unreadNotificationsOnAltsProvider = AutoDisposeProvider<bool>.internal(
  _unreadNotificationsOnAlts,
  name: r'_unreadNotificationsOnAltsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unreadNotificationsOnAltsHash,
  dependencies: <ProviderOrFamily>[
    notificationServiceProvider,
    currentAccountProvider,
    accountManagerProvider
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    notificationServiceProvider,
    ...?notificationServiceProvider.allTransitiveDependencies,
    currentAccountProvider,
    ...?currentAccountProvider.allTransitiveDependencies,
    accountManagerProvider,
    ...?accountManagerProvider.allTransitiveDependencies
  },
);

typedef _UnreadNotificationsOnAltsRef = AutoDisposeProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
