import "package:flutter/widgets.dart" show BuildContext, MediaQuery;

enum WindowClass {
  compact,
  medium,
  expanded;

  factory WindowClass.fromSize(num width) {
    if (width >= 840) return WindowClass.expanded;
    if (width >= 600) return WindowClass.medium;
    return WindowClass.compact;
  }

  factory WindowClass.fromContext(BuildContext context) {
    return WindowClass.fromSize(MediaQuery.of(context).size.width);
  }

  bool operator <(WindowClass b) => index < b.index;
  bool operator >(WindowClass b) => index > b.index;
  bool operator <=(WindowClass b) => index <= b.index;
  bool operator >=(WindowClass b) => index >= b.index;
}
