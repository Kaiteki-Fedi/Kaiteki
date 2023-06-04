import "package:kaiteki_core/model.dart";

const instance = Instance(
  name: "Instance",
);

const alice = User(
  id: "alice",
  displayName: "Alice",
  username: "alice",
  host: "cats.social",
);

final nyanya = User(
  username: "NyaNya",
  displayName: "banned for being a cute neko",
  avatarUrl: Uri.parse("https://craftplacer.keybase.pub/cute.jpg"),
  id: "CuteNeko-Account",
  host: "pl.kawaii.moe",
);

final mari = User(
  id: "ezio",
  username: "ezio",
  host: "akko.wtf",
  displayName: "Mari",
  avatarUrl: Uri.parse("https://files.catbox.moe/lla7hk.png"),
);

final posts = [
  Post(
    id: "0",
    postedAt: DateTime.now(),
    author: alice,
    content: "Is this thing on?",
  ),
  Post(
    author: nyanya,
    content: "Hello everyone! :3",
    postedAt: DateTime.now().add(const Duration(minutes: 5)),
    id: "1",
  ),
  Post(
    id: "2",
    author: mari,
    postedAt: DateTime.now().add(const Duration(minutes: 10)),
    content: "Here's a weird thing to think about\n\n"
        "If you meet an internet friend online: do you refer to them as &lt;actual name&gt; or &lt;online username&gt; in actual conversation?\n\n"
        "I don't know of I'd be able to adapt to the former after knowing XYZ person by their user name :bonk:",
    // emojis: const [
    //   CustomEmoji(short: "bonk", url: "https://files.catbox.moe/ltjc4c.gif"),
    // ],
  ),
];

final users = [alice];
