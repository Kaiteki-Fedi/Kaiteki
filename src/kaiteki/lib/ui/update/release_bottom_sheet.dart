import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:kaiteki/services/updates.dart';
import 'package:kaiteki/theming/default/colors.dart';
import 'package:kaiteki/theming/default/m3_color_schemes.dart';
import 'package:kaiteki/ui/shared/bottom_sheet_drag_handle.dart';
import 'package:kaiteki/ui/shared/common.dart';
import 'package:url_launcher/url_launcher.dart';

class ReleaseBottomSheet extends StatelessWidget {
  final KaitekiRelease release;

  const ReleaseBottomSheet({super.key, required this.release});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BottomSheetDragHandle(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "What's new in ${release.versionName}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: ReleaseThumbnail(
                  children: [
                    Icon(Icons.update_rounded),
                  ],
                ),
              ),
              Markdown(
                styleSheet: MarkdownStyleSheet(
                  h2: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  h2Padding: const EdgeInsets.only(top: 16.0),
                  a: Theme.of(context).colorScheme.primary.textStyle,
                ),
                onTapLink: (text, href, title) async {
                  if (href == null) return;
                  final uri = Uri.tryParse(href);
                  if (uri == null) return;
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                data:
                    """

Between October and November, focus was laid on bringing essential features to the table.

## Notifications

![The new notifications screen as seen in Kaiteki, with read and unread tabs and a 'mark all as read' button]({% link img/november-2022-updates/notifications.jpg%})

A basic feature finally joined in, we now have functioning notifications.

It's not feature complete quite yet, you can check out [issue 56](https://github.com/Kaiteki-Fedi/Kaiteki/issues/56) for more details.

## Emoji picker and reactions

![The new emoji picker with tabs and a search bar]({% link img/november-2022-updates/emoji-picker.png %})

A proper emoji picker is now available. It also supports Unicode emojis, in order to support reactions.


## Experimental Twitter Support

Kaiteki now has support for Twitter, although still has many [flaws]({% link compatibility.html %}#twitter).

<video controls muted>
<source src="{% link vid/A9C81CCB.webm %}" type="video/webm">
</video>

## Attachment changes

### Better alt text support

<img src="{% link img/1D6BBD67.png %}">

You can properly view the alt text of attachments now. Previously they were displayed in the AppBar, but that was very unfriendly for reading descriptive alt text.

## Minor changes

- Fixed `ERR_CLEARTEXT_NOT_PERMITTED` for Android versions
""",
              ),
            ],
          ),
        );
      },
    );
  }
}

class ReleaseThumbnail extends StatelessWidget {
  final List<Widget> children;

  const ReleaseThumbnail({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: darkColorScheme.background,
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: _onShader,
            child: Expanded(
              child: IconTheme(
                data: const IconThemeData(size: 72),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  children: children,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static ui.Shader _onShader(bounds) {
    return ui.Gradient.linear(
      Offset.zero,
      Offset(bounds.right, bounds.bottom),
      [kaitekiPink.shade200, kaitekiOrange.shade200],
    );
  }
}
