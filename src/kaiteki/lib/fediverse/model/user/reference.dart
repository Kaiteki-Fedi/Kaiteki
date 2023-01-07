import 'package:equatable/equatable.dart';
import 'package:kaiteki/utils/extensions.dart';

class UserReference extends Equatable {
  final String? id;
  final String? remoteUrl;
  final String? username;
  final String? host;

  const UserReference(String this.id)
      : remoteUrl = null,
        username = null,
        host = null;

  const UserReference.url(String this.remoteUrl)
      : id = null,
        username = null,
        host = null;

  const UserReference.handle(String this.username, this.host)
      : id = null,
        remoteUrl = null;

  const UserReference.all({
    required String this.username,
    required String this.id,
    required String this.remoteUrl,
    required this.host,
  });

  bool matches(UserReference other) {
    if (id != null && other.id != null) {
      return id == other.id;
    }

    if (remoteUrl != null && other.remoteUrl != null) {
      return remoteUrl == other.remoteUrl;
    }

    if (username != null && other.username != null) {
      return username == other.username && host == other.host;
    }

    return false;
  }

  @override
  String toString() {
    if (username != null && host != null) return '@$username@$host';
    if (username != null) return '@$username';

    if (remoteUrl != null) {
      final parsedUrl = Uri.tryParse(remoteUrl!);
      if (parsedUrl == null) return remoteUrl!;
      final handle = parsedUrl.fediverseHandle;
      return '@${handle.item2}@${handle.item1}';
    }

    if (id != null) return id!;

    return '<unknown>';
  }

  @override
  List<Object?> get props => [id, remoteUrl, username, host];
}
