# Contributing to Kaiteki

I'm happy about any feedback or contribution you have.

Since I am inexperienced with large scale projects, I have nothing against contributors, suggestions, pull requests, questions and anything in-between.

If you have questions you can reach me anywhere on [my contact page](https://craftplacer.moe/about) (preferrably over email), you can also comment under issues that you want to get assigned to and want to work on.

Below is some guidance to what to watch out when working with Kaiteki.

## Code style

Kaiteki has no special formatting rules and follows the standard formatting provided by `dartfmt`.
Here's only one rule though, append a comma when a parameter list gets too long.
This is because Dart's formatter will format it awkwardly.

**BAD**
```dart
const User(
    {required this.id,
    required this.source,
    required this.joinDate,
    ...
    this.followingCount}); // Here's a comma missing
```

**GOOD**
```dart
const User({
  required this.id,
  required this.source,
  required this.joinDate,
  ...
  this.followingCount, // With comma the brackets format correctly.
});
```

## Check your linter problems before submitting a pull request

Kaiteki recently adopted [`flutter_lints`](https://pub.dev/packages/flutter_lints) which provides additional linting rules which show problems ranging from missed `const`s (constant values actually improve performance!) to other suggestions.