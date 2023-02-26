import "package:kaiteki/fediverse/model/model.dart";

const String exampleAvatar = "https://craftplacer.keybase.pub/cute.jpg";

final examplePost = Post(
  author: exampleUser,
  content: "Hello everyone!",
  postedAt: DateTime.now(),
  reactions: [],
  id: "cool-post",
  visibility: Visibility.public,
);

final exampleUser = User(
  username: "NyaNya",
  displayName: "banned for being a cute neko",
  avatarUrl: Uri.parse(exampleAvatar),
  joinDate: DateTime.now(),
  id: "CuteNeko-Account",
  host: "cute.social",
);
