import "package:kaiteki_core/model.dart";

typedef MergedName = (String primary, String secondary);

@pragma("vm:prefer-inline")
MergedName? mergeNameOfUser(User user) {
  return mergeName(user.displayName, user.username, user.host);
}

/// Merges a display name with a username and host.
///
/// Returns `null` if the names cannot be merged.
MergedName? mergeName(String? displayName, String username, String host) {
  final name = displayName ?? username;
  final normalizedDisplay = name.toLowerCase().trim();

  final handle = "$username@$host";
  final similarToHandle = [
    handle.toLowerCase(),
    "@${"handle".toLowerCase()}",
    username.toLowerCase(),
  ];

  if (similarToHandle.contains(normalizedDisplay)) {
    return (name, "@$host");
  }

  return null;
}
