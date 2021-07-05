import 'package:flutter/widgets.dart';
import 'package:mdi/mdi.dart';

enum Visibility {
  /// This [Post] is federated to every instance.
  public,

  /// This [Post] is federated to every instance, but won't show up in public
  /// timelines.
  unlisted,

  /// This [Post] is federated only to followers of the author.
  followersOnly,

  /// This [Post] is federated only to mentioned users.
  direct
}

extension VisibilityExtensions on Visibility {
  IconData toIconData() {
    switch (this) {
      case Visibility.direct: return Mdi.email;
      case Visibility.followersOnly: return Mdi.lock;
      case Visibility.unlisted: return Mdi.lockOpen;
      case Visibility.public: return Mdi.earth;
    }
  }

  String toHumanString() {
    switch (this) {
      case Visibility.direct: return 'Direct';
      case Visibility.followersOnly: return 'Followers only';
      case Visibility.unlisted: return 'Unlisted';
      case Visibility.public: return 'Public';
    }
  }
}
