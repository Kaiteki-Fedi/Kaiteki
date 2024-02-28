import "package:collection/collection.dart";
import "package:kaiteki_core/model.dart";

/// Returns the handles necessary to continue a reply chain/thread.
List<String> continueReplyChain({
  required String currentHandle,
  required String authorHandle,
  List<String> mentionedHandles = const [],
}) {
  final isAuthorInMentions = mentionedHandles.contains(authorHandle);
  final isAuthorCurrentUser = currentHandle == authorHandle;
  return [
    // include the author, IF it IS NOT the current user
    if (!isAuthorCurrentUser && !isAuthorInMentions) authorHandle,
    // include previously mentioned users WITHOUT the current user
    ...mentionedHandles.where((e) => e != currentHandle),
  ];
}

List<String> continueReplyChainFromPost(User currentUser, Post post) {
  final mentionedHandles =
      post.mentionedUsers?.map((e) => e.handle).whereNotNull();

  return continueReplyChain(
    currentHandle: currentUser.handle.toString(),
    authorHandle: post.author.handle.toString(),
    mentionedHandles: mentionedHandles?.toList() ?? const [],
  );
}
