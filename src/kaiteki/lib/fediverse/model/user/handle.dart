import 'package:equatable/equatable.dart';
import 'package:kaiteki/fediverse/model/user/user.dart';

class UserHandle extends Equatable {
  final String username;
  final String host;

  const UserHandle(this.username, this.host);

  factory UserHandle.fromUser(User user) {
    return UserHandle(user.username, user.host);
  }

  @override
  List<Object?> get props => [username, host];

  @override
  String toString() => "@$username@$host";
}
