import "package:kaiteki/utils/reply_chain.dart";
import "package:test/test.dart";

const kCatBoy = "@catboy@nyanya.social";
const kFoxGirl = "@foxgirl@konkon.social";
const kBunnyThing = "@bunnything@pyonpyon.social";

void main() {
  test("user joins thread", () {
    final mentions = continueReplyChain(
      currentHandle: kCatBoy,
      authorHandle: kBunnyThing,
      mentionedHandles: [kBunnyThing, kFoxGirl],
    );

    expect(mentions, orderedEquals([kBunnyThing, kFoxGirl]));
  });

  test("user replies in thread", () {
    final mentions = continueReplyChain(
      currentHandle: kCatBoy,
      authorHandle: kBunnyThing,
      mentionedHandles: [kBunnyThing, kFoxGirl],
    );

    expect(mentions, orderedEquals([kBunnyThing, kFoxGirl]));
  });

  test("user replies in thread with self-mention of author", () {
    final mentions = continueReplyChain(
      currentHandle: kCatBoy,
      authorHandle: kBunnyThing,
      mentionedHandles: [kBunnyThing, kFoxGirl, kCatBoy],
    );

    expect(mentions, orderedEquals([kBunnyThing, kFoxGirl]));
  });

  test("user continues thread", () {
    final mentions = continueReplyChain(
      currentHandle: kCatBoy,
      authorHandle: kCatBoy,
      mentionedHandles: [kBunnyThing, kFoxGirl],
    );

    expect(mentions, orderedEquals([kBunnyThing, kFoxGirl]));
  });
}
