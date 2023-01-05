import 'dart:async';

import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/model/model.dart';

abstract class Resolvable<K, V> {
  final K id;
  final V? data;

  const Resolvable(this.id, this.data);
}

class ResolvableUser implements Resolvable<String, User> {
  @override
  final User? data;

  @override
  final String id;

  const ResolvableUser._(this.id, this.data);

  factory ResolvableUser.fromId(String id) => ResolvableUser._(id, null);
  factory ResolvableUser.fromData(User user) => ResolvableUser._(user.id, user);

  FutureOr<User> resolve(BackendAdapter adapter) {
    if (data != null) return data!;
    return adapter.getUserById(id);
  }
}

extension ResolvableUserExtension on User {
  ResolvableUser get resolved => ResolvableUser.fromData(this);
}

class ResolvablePost implements Resolvable<String, Post> {
  @override
  final Post? data;

  @override
  final String id;

  const ResolvablePost._(this.id, this.data);

  factory ResolvablePost.fromId(String id) => ResolvablePost._(id, null);
  factory ResolvablePost.fromData(Post post) => ResolvablePost._(post.id, post);

  FutureOr<Post> resolve(BackendAdapter adapter) {
    if (data != null) return data!;
    return adapter.getPostById(id);
  }
}

extension ResolvablePostExtension on Post {
  ResolvablePost get resolved => ResolvablePost.fromData(this);
}
