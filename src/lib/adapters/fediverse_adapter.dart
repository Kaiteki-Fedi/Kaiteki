import 'dart:async';

import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/api/clients/fediverse_client_base.dart';
import 'package:kaiteki/auth/login_typedefs.dart';
import 'package:kaiteki/model/auth/login_result.dart';
import 'package:kaiteki/model/fediverse/notification.dart';
import 'package:kaiteki/model/fediverse/post.dart';
import 'package:kaiteki/model/fediverse/user.dart';
import 'package:kaiteki/model/fediverse/timeline_type.dart';

/// An adapter containing a backing Fediverse client that.
abstract class FediverseAdapter<Client extends FediverseClientBase> {
  /// The original client/backend that is being adapted.
  Client client;

  FediverseAdapter(this.client);

  /// Retrieves the profile of the currently authenticated user. If null gets
  /// provided we may assume there was an error.
  Future<User> getMyself();

  Future<LoginResult> login(String instance, String username, String password, MfaCallback mfaCallback, AccountContainer accounts);

  /// Retrieves an user of another instance
  Future<User> getUser(String username, [String instance]);

  /// Retrieves an user using an instance specific ID.
  Future<User> getUserById(String id);

  Future<Post> postStatus(Post post);

  Future<Iterable<Post>> getTimeline(TimelineType type);

  Future<Iterable<Notification>> getNotifications();

  Future<Iterable<Post>> getStatusesOfUserById(String id);
}