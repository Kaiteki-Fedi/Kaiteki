import 'package:flutter/widgets.dart';
import 'package:mdi/mdi.dart';

enum Visibility {
  /// This [Post] is federated to every instance.
  Public,

  /// This [Post] is federated to every instance, but won't show up in public
  /// timelines.
  Unlisted,

  /// This [Post] is federated only to followers of the author.
  FollowersOnly,

  /// This [Post] is federated only to mentioned users.
  Direct
}

extension VisibilityExtensions on Visibility {
  IconData toIconData() {
    switch (this) {
      case Visibility.Direct:
        return Mdi.email;
      case Visibility.FollowersOnly:
        return Mdi.lock;
      case Visibility.Unlisted:
        return Mdi.lockOpen;
      case Visibility.Public:
        return Mdi.earth;
      default:
        throw new Exception("The provided visibility is out of range.");
    }
  }
}
