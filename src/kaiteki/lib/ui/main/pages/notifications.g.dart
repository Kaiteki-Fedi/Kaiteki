// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$announcementsSupportedHash() =>
    r'a86aa2cb746c47bc6a83da85083c7e02227959b1';

/// See also [_announcementsSupported].
@ProviderFor(_announcementsSupported)
final _announcementsSupportedProvider = AutoDisposeProvider<bool>.internal(
  _announcementsSupported,
  name: r'_announcementsSupportedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$announcementsSupportedHash,
  dependencies: <ProviderOrFamily>[adapterProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    adapterProvider,
    ...?adapterProvider.allTransitiveDependencies
  },
);

typedef _AnnouncementsSupportedRef = AutoDisposeProviderRef<bool>;

String _$followingSupportedHash() =>
    r'142ee3f4d4eb70047a377dd8af7902f3e0e6c702';

/// See also [_followingSupported].
@ProviderFor(_followingSupported)
final _followingSupportedProvider = AutoDisposeProvider<bool>.internal(
  _followingSupported,
  name: r'_followingSupportedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$followingSupportedHash,
  dependencies: <ProviderOrFamily>[adapterProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    adapterProvider,
    ...?adapterProvider.allTransitiveDependencies
  },
);

typedef _FollowingSupportedRef = AutoDisposeProviderRef<bool>;

String _$followRequestCountHash() =>
    r'd4a2f755d0bf7a75ef269e656578816e97da7b94';

/// See also [_followRequestCount].
@ProviderFor(_followRequestCount)
final _followRequestCountProvider =
    FutureProvider<(int count, bool hasMore)?>.internal(
  _followRequestCount,
  name: r'_followRequestCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$followRequestCountHash,
  dependencies: <ProviderOrFamily>[
    currentAccountProvider,
    followRequestsServiceProvider
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    currentAccountProvider,
    ...?currentAccountProvider.allTransitiveDependencies,
    followRequestsServiceProvider,
    ...?followRequestsServiceProvider.allTransitiveDependencies
  },
);

typedef _FollowRequestCountRef = FutureProviderRef<(int count, bool hasMore)?>;

String _$unreadAnnouncementCountHash() =>
    r'bae26132eb44cb04b63c145b6ed7ecfd48971aa1';

/// See also [_unreadAnnouncementCount].
@ProviderFor(_unreadAnnouncementCount)
final _unreadAnnouncementCountProvider = FutureProvider<int>.internal(
  _unreadAnnouncementCount,
  name: r'_unreadAnnouncementCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unreadAnnouncementCountHash,
  dependencies: <ProviderOrFamily>[
    currentAccountProvider,
    announcementsServiceProvider
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    currentAccountProvider,
    ...?currentAccountProvider.allTransitiveDependencies,
    announcementsServiceProvider,
    ...?announcementsServiceProvider.allTransitiveDependencies
  },
);

typedef _UnreadAnnouncementCountRef = FutureProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
