import 'package:kaiteki/fediverse/model/model.dart';

const instance = Instance(
  name: "Instance",
  source: null,
);

const alice = User(
  source: null,
  id: "alice",
  displayName: "Alice",
  username: "alice",
  host: "cats.social",
  bannerUrl:
      "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn1-www.cattime.com%2Fassets%2Fuploads%2F2015%2F08%2Forange-cat-e1555715572481.jpg&f=1&nofb=1&ipt=6ba89559e768f1274fafbf48179afd61a206711c898536aa3b6379da528751f3&ipo=images",
);

const nyanya = User(
  username: "NyaNya",
  displayName: "banned for being a cute neko",
  avatarUrl: "https://craftplacer.keybase.pub/cute.jpg",
  id: "CuteNeko-Account",
  source: null,
  host: 'pl.kawaii.moe',
);

const mari = User(
  source: null,
  id: "ezio",
  username: "ezio",
  host: "akko.wtf",
  displayName: "Mari",
  avatarUrl:
      "https://akko.wtf/media/aaaf1527cbe86357e21a8b24e262188f1117f3c5b9ad342b30723f2aa4a8ee93.png",
);

final posts = [
  Post(
    source: null,
    id: "0",
    postedAt: DateTime.now(),
    author: alice,
    content: "Is this thing on?",
  ),
  Post(
    author: nyanya,
    content: "Hello everyone! :3",
    source: null,
    postedAt: DateTime.now().add(const Duration(minutes: 5)),
    id: '1',
  ),
  Post(
    source: null,
    id: "2",
    author: mari,
    postedAt: DateTime.now().add(const Duration(minutes: 10)),
    content: "Here's a weird thing to think about\n\n"
        "If you meet an internet friend online: do you refer to them as &lt;actual name&gt; or &lt;online username&gt; in actual conversation?\n\n"
        "I don't know of I'd be able to adapt to the former after knowing XYZ person by their user name :bonk:",
    emojis: const [
      CustomEmoji(name: "bonk", url: "https://akko.wtf/emoji/bonk/bonk.gif"),
    ],
  ),
];

final users = [alice];
